//
//  ApproveCallData.swift
//
//  Created by Sun on 2021/6/9.
//

import Foundation

import BigInt
import EVMKit
import SWExtensions

// MARK: - ApproveCallData

public struct ApproveCallData {
    // MARK: Properties

    public let data: Data
    public let gasPrice: Int
    public let to: Address
    public let value: BigUInt

    // MARK: Lifecycle

    init(data: Data, gasPrice: Int, to: Address, value: BigUInt) {
        self.data = data
        self.gasPrice = gasPrice
        self.to = to
        self.value = value
    }
}

// MARK: CustomStringConvertible

extension ApproveCallData: CustomStringConvertible {
    public var description: String {
        "[ApproveCallData: \nto: \(to.hex); \nvalue: \(value.description); \ndata: \(data.sw.hex)]"
    }
}
