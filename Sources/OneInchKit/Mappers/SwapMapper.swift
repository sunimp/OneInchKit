//
//  SwapMapper.swift
//  OneInchKit
//
//  Created by Sun on 2021/6/9.
//

import Foundation

import BigInt

// MARK: - SwapMapper

enum SwapMapper {
    static func swap(map: [String: Any]) throws -> Swap {
        guard
            let fromTokenMap = map["fromToken"] as? [String: Any],
            let toTokenMap = map["toToken"] as? [String: Any],
            let transactionMap = map["tx"] as? [String: Any]
        else {
            throw ResponseError.invalidJson
        }

        let fromToken = try TokenMapper.token(map: fromTokenMap)
        let toToken = try TokenMapper.token(map: toTokenMap)
        let transaction = try SwapTransactionMapper.swapTransaction(map: transactionMap)

        guard
            let toAmountString = map["toAmount"] as? String,
            let toAmount = BigUInt(toAmountString, radix: 10)
        else {
            throw ResponseError.invalidJson
        }

        return Swap(
            fromToken: fromToken,
            toToken: toToken,
            toTokenAmount: toAmount,
            route: [], // TODO: parse "protocols"
            transaction: transaction
        )
    }
}

// MARK: SwapMapper.ResponseError

extension SwapMapper {
    public enum ResponseError: Error {
        case invalidJson
    }
}
