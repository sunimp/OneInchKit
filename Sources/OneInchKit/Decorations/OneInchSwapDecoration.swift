//
//  OneInchSwapDecoration.swift
//  OneInchKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import BigInt
import EVMKit

public class OneInchSwapDecoration: OneInchDecoration {
    // MARK: Properties

    public let tokenIn: Token
    public let tokenOut: Token
    public let amountIn: BigUInt
    public let amountOut: Amount
    public let flags: BigUInt
    public let permit: Data
    public let data: Data
    public let recipient: Address?

    // MARK: Lifecycle

    public init(
        contractAddress: Address,
        tokenIn: Token,
        tokenOut: Token,
        amountIn: BigUInt,
        amountOut: Amount,
        flags: BigUInt,
        permit: Data,
        data: Data,
        recipient: Address?
    ) {
        self.tokenIn = tokenIn
        self.tokenOut = tokenOut
        self.amountIn = amountIn
        self.amountOut = amountOut
        self.flags = flags
        self.permit = permit
        self.data = data
        self.recipient = recipient

        super.init(contractAddress: contractAddress)
    }

    // MARK: Overridden Functions

    override public func tags() -> [TransactionTag] {
        var tags = [TransactionTag]()

        let addresses = recipient.map { [$0.hex] } ?? []

        tags.append(tag(token: tokenIn, type: .swap, addresses: addresses))
        tags.append(tag(token: tokenOut, type: .swap, addresses: addresses))

        tags.append(tag(token: tokenIn, type: .outgoing, addresses: addresses))

        if recipient == nil {
            tags.append(tag(token: tokenOut, type: .incoming))
        }

        return tags
    }
}
