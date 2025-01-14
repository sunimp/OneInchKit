//
//  Kit.swift
//  OneInchKit
//
//  Created by Sun on 2021/6/9.
//

import Foundation

import BigInt
import EVMKit
import SWToolKit

// MARK: - Kit

public class Kit {
    // MARK: Properties

    private let provider: OneInchProvider

    // MARK: Lifecycle

    init(provider: OneInchProvider) {
        self.provider = provider
    }
}

extension Kit {
    public func quote(
        networkManager: NetworkManager,
        chain: Chain,
        fromToken: Address,
        toToken: Address,
        amount: BigUInt,
        fee: Decimal? = nil,
        protocols: String? = nil,
        gasPrice: GasPrice? = nil,
        complexityLevel: Int? = nil,
        connectorTokens: String? = nil,
        gasLimit: Int? = nil,
        mainRouteParts: Int? = nil,
        parts: Int? = nil
    ) async throws
        -> Quote {
        try await provider.quote(
            networkManager: networkManager,
            chain: chain,
            fromToken: fromToken,
            toToken: toToken,
            amount: amount,
            fee: fee,
            protocols: protocols,
            gasPrice: gasPrice,
            complexityLevel: complexityLevel,
            connectorTokens: connectorTokens,
            gasLimit: gasLimit,
            mainRouteParts: mainRouteParts,
            parts: parts
        )
    }

    public func swap(
        networkManager: NetworkManager,
        chain: Chain,
        receiveAddress: Address,
        fromToken: Address,
        toToken: Address,
        amount: BigUInt,
        slippage: Decimal,
        referrer: String? = nil,
        fee: Decimal? = nil,
        protocols: [String]? = nil,
        recipient: Address? = nil,
        gasPrice: GasPrice? = nil,
        burnChi: Bool? = nil,
        complexityLevel: Int? = nil,
        connectorTokens: [String]? = nil,
        allowPartialFill: Bool? = nil,
        gasLimit: Int? = nil,
        mainRouteParts: Int? = nil,
        parts: Int? = nil
    ) async throws
        -> Swap {
        try await provider.swap(
            networkManager: networkManager,
            chain: chain,
            fromToken: fromToken.hex,
            toToken: toToken.hex,
            amount: amount,
            fromAddress: receiveAddress.hex,
            slippage: slippage,
            referrer: referrer,
            fee: fee,
            protocols: protocols?.joined(separator: ","),
            recipient: recipient?.hex,
            gasPrice: gasPrice,
            burnChi: burnChi,
            complexityLevel: complexityLevel,
            connectorTokens: connectorTokens?.joined(separator: ","),
            allowPartialFill: allowPartialFill,
            gasLimit: gasLimit,
            mainRouteParts: mainRouteParts,
            parts: parts
        )
    }
}

extension Kit {
    public static func instance(apiKey: String) -> Kit {
        Kit(provider: OneInchProvider(apiKey: apiKey))
    }

    public static func addDecorators(to evmKit: EVMKit.Kit) {
        evmKit
            .add(methodDecorator: OneInchMethodDecorator(
                contractMethodFactories: OneInchContractMethodFactories
                    .shared
            ))
        evmKit.add(transactionDecorator: OneInchTransactionDecorator(address: evmKit.address))
    }

    public static func routerAddress(chain: Chain) throws -> Address {
        switch chain.id {
        case 1,
             10,
             56,
             100,
             137,
             250,
             42161,
             43114: return try Address(hex: "0x1111111254EEB25477B68fb85Ed929f73A960582")
        case 3,
             4,
             5,
             42: return try Address(hex: "0x11111112542d85b3ef69ae05771c2dccff4faa26")
        default: throw UnsupportedChainError.noRouterAddress
        }
    }
}

extension Kit {
    public enum UnsupportedChainError: Error {
        case noRouterAddress
    }

    public enum QuoteError: Error {
        case insufficientLiquidity
    }

    public enum SwapError: Error {
        case notEnough
        case cannotEstimate
    }
}

extension BigUInt {
    public func toDecimal(decimals: Int) -> Decimal? {
        guard let decimalValue = Decimal(string: description) else {
            return nil
        }

        return decimalValue / pow(10, decimals)
    }
}
