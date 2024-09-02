//
//  Swap.swift
//
//  Created by Sun on 2021/6/9.
//

import Foundation

import BigInt

// MARK: - Swap

public struct Swap {
    // MARK: Properties

    public let fromToken: Token
    public let toToken: Token
    public let toTokenAmount: BigUInt
    public let route: [Any]
    public let transaction: SwapTransaction

    // MARK: Lifecycle

    public init(fromToken: Token, toToken: Token, toTokenAmount: BigUInt, route: [Any], transaction: SwapTransaction) {
        self.fromToken = fromToken
        self.toToken = toToken
        self.toTokenAmount = toTokenAmount
        self.route = route
        self.transaction = transaction
    }
}

// MARK: CustomStringConvertible

extension Swap: CustomStringConvertible {
    public var description: String {
        "[Swap {\nfromToken:\(fromToken.name) - \ntoToken:\(toToken.name); \ntoAmount: \(toTokenAmount.description) \ntx: \(transaction.description)]"
    }
}

extension Swap {
    public var amountOut: Decimal? {
        toTokenAmount.toDecimal(decimals: toToken.decimals)
    }
}
