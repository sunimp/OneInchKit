//
//  OneInchDecoration.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import Eip20Kit
import EvmKit

// MARK: - OneInchDecoration

open class OneInchDecoration: TransactionDecoration {
    public let contractAddress: Address
    
    public init(contractAddress: Address) {
        self.contractAddress = contractAddress
    }
    
    func tag(token: Token, type: TransactionTag.TagType, addresses: [String] = []) -> TransactionTag {
        switch token {
        case .evmCoin: TransactionTag(type: type, protocol: .native, addresses: addresses)
        case .eip20Coin(let tokenAddress, _): TransactionTag(
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
        
        public var tokenInfo: TokenInfo? {
            switch self {
            case .eip20Coin(_, let tokenInfo):
                tokenInfo
            default:
                nil
            }
        }
    }
}
