//
//  OneInchUnknownSwapDecoration.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

// MARK: - OneInchUnknownSwapDecoration

public class OneInchUnknownSwapDecoration: OneInchDecoration {
    
    public let tokenAmountIn: TokenAmount?
    public let tokenAmountOut: TokenAmount?

    init(contractAddress: Address, tokenAmountIn: TokenAmount?, tokenAmountOut: TokenAmount?) {
        self.tokenAmountIn = tokenAmountIn
        self.tokenAmountOut = tokenAmountOut

        super.init(contractAddress: contractAddress)
    }

    override public func tags() -> [TransactionTag] {
        var tags = [TransactionTag]()

        if let tokenIn = tokenAmountIn?.token {
            tags.append(tag(token: tokenIn, type: .swap))
            tags.append(tag(token: tokenIn, type: .outgoing))
        }

        if let tokenOut = tokenAmountOut?.token {
            tags.append(tag(token: tokenOut, type: .swap))
            tags.append(tag(token: tokenOut, type: .incoming))
        }

        return tags
    }
}

// MARK: OneInchUnknownSwapDecoration.TokenAmount

extension OneInchUnknownSwapDecoration {
    
    public struct TokenAmount {
        public let token: Token
        public let value: BigUInt
    }
}
