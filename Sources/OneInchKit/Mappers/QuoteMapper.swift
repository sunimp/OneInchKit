//
//  QuoteMapper.swift
//
//  Created by Sun on 2021/6/9.
//

import Foundation

import BigInt

// MARK: - QuoteMapper

enum QuoteMapper {
    static func quote(map: [String: Any]) throws -> Quote {
        guard
            let fromTokenMap = map["fromToken"] as? [String: Any],
            let toTokenMap = map["toToken"] as? [String: Any]
        else {
            throw ResponseError.invalidJson
        }

        let fromToken = try TokenMapper.token(map: fromTokenMap)
        let toToken = try TokenMapper.token(map: toTokenMap)

        guard
            let toAmountString = map["toAmount"] as? String,
            let toAmount = BigUInt(toAmountString, radix: 10),
            let estimateGas = map["gas"] as? Int
        else {
            throw ResponseError.invalidJson
        }

        return Quote(
            fromToken: fromToken,
            toToken: toToken,
            toTokenAmount: toAmount,
            route: [], // TODO: parse "protocols"
            estimateGas: estimateGas
        )
    }
}

// MARK: QuoteMapper.ResponseError

extension QuoteMapper {
    public enum ResponseError: Error {
        case invalidJson
    }
}
