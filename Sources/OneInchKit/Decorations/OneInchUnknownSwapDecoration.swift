//
//  OneInchUnknownSwapDecoration.swift
//  OneInchKit
//
//  Created by Sun on 2022/4/14.
//

import Foundation

import BigInt
import EVMKit

// MARK: - OneInchUnknownSwapDecoration

public class OneInchUnknownSwapDecoration: OneInchDecoration {
    // MARK: Properties

    public let tokenAmountIn: TokenAmount?
    public let tokenAmountOut: TokenAmount?

    // MARK: Lifecycle

    init(contractAddress: Address, tokenAmountIn: TokenAmount?, tokenAmountOut: TokenAmount?) {
        self.tokenAmountIn = tokenAmountIn
        self.tokenAmountOut = tokenAmountOut

        super.init(contractAddress: contractAddress)
    }

    // MARK: Overridden Functions

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
