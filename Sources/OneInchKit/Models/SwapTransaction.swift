//
//  SwapTransaction.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit
import WWExtensions

public struct SwapTransaction {
    
    public let from: Address
    public let to: Address
    public let data: Data
    public let value: BigUInt
    public let gasPrice: GasPrice
    public let gasLimit: Int

    public init(from: Address, to: Address, data: Data, value: BigUInt, gasPrice: GasPrice, gasLimit: Int) {
        self.from = from
        self.to = to
        self.data = data
        self.value = value
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
    }
}

extension SwapTransaction: CustomStringConvertible {
    public var description: String {
        "[SwapTransaction {from \(from.hex); to: \(to.hex); data: \(data.ww.hex); value: \(value.description); gasPrice: \(gasPrice); gasLimit: \(gasLimit)]"
    }
}
