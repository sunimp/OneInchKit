//
//  OneInchTransactionDecorator.swift
//  OneInchKit
//
//  Created by Sun on 2021/7/6.
//

import Foundation

import BigInt
import EIP20Kit
import EVMKit

// MARK: - OneInchTransactionDecorator

class OneInchTransactionDecorator {
    // MARK: Static Properties

    private static let ethTokenAddresses = [
        "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE",
        "0x0000000000000000000000000000000000000000",
    ]

    // MARK: Properties

    private let address: Address

    // MARK: Lifecycle

    init(address: Address) {
        self.address = address
    }

    // MARK: Functions

    private func incomingTransfers(
        userAddress: Address,
        eventInstances: [ContractEventInstance]
    )
        -> [TransferEventInstance] {
        eventInstances.compactMap {
            if let transferEventInstance = $0 as? TransferEventInstance, transferEventInstance.to == userAddress {
                transferEventInstance
            } else {
                nil
            }
        }
    }

    private func outgoingTransfers(
        userAddress: Address,
        eventInstances: [ContractEventInstance]
    )
        -> [TransferEventInstance] {
        eventInstances.compactMap {
            if let transferEventInstance = $0 as? TransferEventInstance, transferEventInstance.from == userAddress {
                transferEventInstance
            } else {
                nil
            }
        }
    }

    private func totalAmount(tokenAddress: Address, transfers: [TransferEventInstance]) -> BigUInt {
        var amount: BigUInt = 0

        for transfer in transfers {
            if transfer.contractAddress == tokenAddress {
                amount += transfer.value
            }
        }

        return amount
    }

    private func totalEthIncoming(userAddress: Address, internalTransactions: [InternalTransaction]) -> BigUInt {
        var amount: BigUInt = 0

        for internalTransaction in internalTransactions {
            if internalTransaction.to == userAddress {
                amount += internalTransaction.value
            }
        }

        return amount
    }

    private func addressToToken(address: Address, eventInstances: [ContractEventInstance]) -> OneInchDecoration.Token {
        let eip55Address = address.eip55

        if OneInchTransactionDecorator.ethTokenAddresses.contains(eip55Address) {
            return .evmCoin
        } else {
            return .eip20Coin(
                address: address,
                tokenInfo: eventInstances.compactMap { $0 as? TransferEventInstance }
                    .first { $0.contractAddress == address }?
                    .tokenInfo
            )
        }
    }
}

// MARK: ITransactionDecorator

extension OneInchTransactionDecorator: ITransactionDecorator {
    public func decoration(
        from: Address?,
        to: Address?,
        value: BigUInt?,
        contractMethod: ContractMethod?,
        internalTransactions: [InternalTransaction],
        eventInstances: [ContractEventInstance]
    )
        -> TransactionDecoration? {
        guard let from, let to, let value, let contractMethod else {
            return nil
        }

        switch contractMethod {
        case let method as SwapMethodV4:
            let swapDescription = method.swapDescription
            let tokenOut = addressToToken(address: swapDescription.dstToken, eventInstances: eventInstances)

            var amountOut: OneInchDecoration.Amount = .extremum(value: swapDescription.minReturnAmount)

            switch tokenOut {
            case .evmCoin:
                if !internalTransactions.isEmpty {
                    amountOut = .exact(value: totalEthIncoming(
                        userAddress: swapDescription.dstReceiver,
                        internalTransactions: internalTransactions
                    ))
                }

            case .eip20Coin:
                let totalAmount = totalAmount(
                    tokenAddress: swapDescription.dstToken,
                    transfers: incomingTransfers(
                        userAddress: swapDescription.dstReceiver,
                        eventInstances: eventInstances
                    )
                )
                if totalAmount != 0 {
                    amountOut = .exact(value: totalAmount)
                }
            }

            return OneInchSwapDecoration(
                contractAddress: to,
                tokenIn: addressToToken(address: swapDescription.srcToken, eventInstances: eventInstances),
                tokenOut: tokenOut,
                amountIn: swapDescription.amount,
                amountOut: amountOut,
                flags: swapDescription.flags,
                permit: swapDescription.permit,
                data: method.data,
                recipient: swapDescription.dstReceiver == from ? nil : swapDescription.dstReceiver
            )

        case let method as UnoswapMethodV4:
            var tokenOut: OneInchDecoration.Token?
            var amountOut: OneInchDecoration.Amount = .extremum(value: method.minReturn)

            if !internalTransactions.isEmpty {
                let amount = totalEthIncoming(userAddress: address, internalTransactions: internalTransactions)

                if amount > 0 {
                    tokenOut = .evmCoin
                    amountOut = .exact(value: amount)
                }
            }

            let incomingTransfers = incomingTransfers(userAddress: address, eventInstances: eventInstances)
            if tokenOut == nil, let firstTransfer = incomingTransfers.first {
                let amount = totalAmount(tokenAddress: firstTransfer.contractAddress, transfers: incomingTransfers)

                if amount > 0 {
                    tokenOut = addressToToken(address: firstTransfer.contractAddress, eventInstances: eventInstances)
                    amountOut = .exact(value: amount)
                }
            }

            return OneInchUnoswapDecoration(
                contractAddress: to,
                tokenIn: addressToToken(address: method.srcToken, eventInstances: eventInstances),
                tokenOut: tokenOut,
                amountIn: method.amount,
                amountOut: amountOut,
                params: method.params
            )

        case let method as SwapMethodV5:
            let swapDescription = method.swapDescription
            let tokenOut = addressToToken(address: swapDescription.dstToken, eventInstances: eventInstances)

            var amountOut: OneInchDecoration.Amount = .extremum(value: swapDescription.minReturnAmount)

            switch tokenOut {
            case .evmCoin:
                if !internalTransactions.isEmpty {
                    amountOut = .exact(value: totalEthIncoming(
                        userAddress: swapDescription.dstReceiver,
                        internalTransactions: internalTransactions
                    ))
                }

            case .eip20Coin:
                let totalAmount = totalAmount(
                    tokenAddress: swapDescription.dstToken,
                    transfers: incomingTransfers(
                        userAddress: swapDescription.dstReceiver,
                        eventInstances: eventInstances
                    )
                )
                if totalAmount != 0 {
                    amountOut = .exact(value: totalAmount)
                }
            }

            return OneInchSwapDecoration(
                contractAddress: to,
                tokenIn: addressToToken(address: swapDescription.srcToken, eventInstances: eventInstances),
                tokenOut: tokenOut,
                amountIn: swapDescription.amount,
                amountOut: amountOut,
                flags: swapDescription.flags,
                permit: method.permit,
                data: method.data,
                recipient: swapDescription.dstReceiver == from ? nil : swapDescription.dstReceiver
            )

        case let method as UnoswapMethodV5:
            var tokenOut: OneInchDecoration.Token?
            var amountOut: OneInchDecoration.Amount = .extremum(value: method.minReturn)

            if !internalTransactions.isEmpty {
                let amount = totalEthIncoming(userAddress: address, internalTransactions: internalTransactions)

                if amount > 0 {
                    tokenOut = .evmCoin
                    amountOut = .exact(value: amount)
                }
            }

            let incomingTransfers = incomingTransfers(userAddress: address, eventInstances: eventInstances)
            if tokenOut == nil, let firstTransfer = incomingTransfers.first {
                let amount = totalAmount(tokenAddress: firstTransfer.contractAddress, transfers: incomingTransfers)

                if amount > 0 {
                    tokenOut = addressToToken(address: firstTransfer.contractAddress, eventInstances: eventInstances)
                    amountOut = .exact(value: amount)
                }
            }

            return OneInchUnoswapDecoration(
                contractAddress: to,
                tokenIn: addressToToken(address: method.srcToken, eventInstances: eventInstances),
                tokenOut: tokenOut,
                amountIn: method.amount,
                amountOut: amountOut,
                params: []
            )

        case is UnparsedSwapMethodV4,
             is UnparsedSwapMethodV5:
            var totalInternalValue: BigUInt = 0

            for internalTransaction in internalTransactions {
                totalInternalValue += internalTransaction.value
            }

            let outgoingTransfers = outgoingTransfers(userAddress: address, eventInstances: eventInstances)
            let incomingTransfers = incomingTransfers(userAddress: address, eventInstances: eventInstances)

            var tokenAmountIn: OneInchUnknownSwapDecoration.TokenAmount?

            if value > totalInternalValue {
                tokenAmountIn = OneInchUnknownSwapDecoration.TokenAmount(
                    token: .evmCoin,
                    value: value - totalInternalValue
                )
            } else if let firstTransfer = outgoingTransfers.first {
                let total = totalAmount(tokenAddress: firstTransfer.contractAddress, transfers: outgoingTransfers)
                tokenAmountIn = OneInchUnknownSwapDecoration.TokenAmount(
                    token: addressToToken(address: firstTransfer.contractAddress, eventInstances: eventInstances),
                    value: total
                )
            }

            var tokenAmountOut: OneInchUnknownSwapDecoration.TokenAmount?

            if value < totalInternalValue {
                tokenAmountOut = OneInchUnknownSwapDecoration.TokenAmount(
                    token: .evmCoin,
                    value: totalInternalValue - value
                )
            } else if let firstTransfer = incomingTransfers.first {
                let total = totalAmount(tokenAddress: firstTransfer.contractAddress, transfers: incomingTransfers)
                tokenAmountOut = OneInchUnknownSwapDecoration.TokenAmount(
                    token: addressToToken(address: firstTransfer.contractAddress, eventInstances: eventInstances),
                    value: total
                )
            }

            return OneInchUnknownSwapDecoration(
                contractAddress: to,
                tokenAmountIn: tokenAmountIn,
                tokenAmountOut: tokenAmountOut
            )

        default: return nil
        }
    }
}
