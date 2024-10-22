//
//  SwapTransaction.swift
//
//  Created by Sun on 2021/6/9.
//

import Foundation

import BigInt
import EVMKit
import SWExtensions

// MARK: - SwapTransaction

public struct SwapTransaction {
    // MARK: Properties

    public let from: Address
    public let to: Address
    public let data: Data
    public let value: BigUInt
    public let gasPrice: GasPrice
    public let gasLimit: Int

    // MARK: Lifecycle

    public init(from: Address, to: Address, data: Data, value: BigUInt, gasPrice: GasPrice, gasLimit: Int) {
        self.from = from
        self.to = to
        self.data = data
        self.value = value
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
    }
}

// MARK: CustomStringConvertible

extension SwapTransaction: CustomStringConvertible {
    public var description: String {
        "[SwapTransaction {from \(from.hex); to: \(to.hex); data: \(data.sw.hex); value: \(value.description); gasPrice: \(gasPrice); gasLimit: \(gasLimit)]"
    }
}
