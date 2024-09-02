//
//  OneInchDecoration.swift
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import BigInt
import EIP20Kit
import EVMKit

// MARK: - OneInchDecoration

open class OneInchDecoration: TransactionDecoration {
    // MARK: Properties

    public let contractAddress: Address

    // MARK: Lifecycle

    public init(contractAddress: Address) {
        self.contractAddress = contractAddress
    }

    // MARK: Functions

    func tag(token: Token, type: TransactionTag.TagType, addresses: [String] = []) -> TransactionTag {
        switch token {
        case .evmCoin: TransactionTag(type: type, protocol: .native, addresses: addresses)
        case let .eip20Coin(tokenAddress, _): TransactionTag(
                type: type,
                protocol: .eip20,
                contractAddress: tokenAddress,
                addresses: addresses
            )
        }
    }
}

extension OneInchDecoration {
    public enum Amount {
        case exact(value: BigUInt)
        case extremum(value: BigUInt)
    }
    
    public enum Token {
        case evmCoin
        case eip20Coin(address: Address, tokenInfo: TokenInfo?)

        // MARK: Computed Properties

        public var tokenInfo: TokenInfo? {
            switch self {
            case let .eip20Coin(_, tokenInfo):
                tokenInfo
            default:
                nil
            }
        }
    }
}
