//
//  Quote.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt

// MARK: - Quote

public struct Quote {
    
    public let fromToken: Token
    public let toToken: Token
    public let toTokenAmount: BigUInt
    public let route: [Any]
    public let estimateGas: Int

    public init(fromToken: Token, toToken: Token, toTokenAmount: BigUInt, route: [Any], estimateGas: Int) {
        self.fromToken = fromToken
        self.toToken = toToken
        self.toTokenAmount = toTokenAmount
        self.route = route
        self.estimateGas = estimateGas
    }
}

// MARK: CustomStringConvertible

extension Quote: CustomStringConvertible {
    public var description: String {
        "[Quote {fromToken:\(fromToken.name) - toToken:\(toToken.name); toAmount: \(toTokenAmount.description)]"
    }
}

extension Quote {
    
    public var amountOut: Decimal? {
        toTokenAmount.toDecimal(decimals: toToken.decimals)
    }
}
