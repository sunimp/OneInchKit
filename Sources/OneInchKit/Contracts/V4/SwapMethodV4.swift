//
//  SwapMethodV4.swift
//  OneInchKit
//
//  Created by Sun on 2021/7/6.
//

import Foundation

import BigInt
import EVMKit

class SwapMethodV4: ContractMethod {
    // MARK: Nested Types

    struct SwapDescription {
        let srcToken: Address
        let dstToken: Address
        let srcReceiver: Address
        let dstReceiver: Address
        let amount: BigUInt
        let minReturnAmount: BigUInt
        let flags: BigUInt
        let permit: Data
    }

    // MARK: Static Properties

    static let methodSignature = "swap(address,(address,address,address,address,uint256,uint256,uint256,bytes),bytes)"

    // MARK: Overridden Properties

    override var methodSignature: String { SwapMethodV4.methodSignature }

    override var arguments: [Any] {
        [caller, swapDescription, data]
    }

    // MARK: Properties

    let caller: Address
    let swapDescription: SwapDescription
    let data: Data

    // MARK: Lifecycle

    init(caller: Address, swapDescription: SwapDescription, data: Data) {
        self.caller = caller
        self.swapDescription = swapDescription
        self.data = data

        super.init()
    }
}
