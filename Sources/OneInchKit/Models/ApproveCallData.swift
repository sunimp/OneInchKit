//
//  ApproveCallData.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit
import WWExtensions

// MARK: - ApproveCallData

public struct ApproveCallData {
    public let data: Data
    public let gasPrice: Int
    public let to: Address
    public let value: BigUInt

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
        "[ApproveCallData: \nto: \(to.hex); \nvalue: \(value.description); \ndata: \(data.ww.hex)]"
    }
}
