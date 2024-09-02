//
//  SwapMethodV5.swift
//
//  Created by Sun on 2021/7/6.
//

import Foundation

import BigInt
import EVMKit

class SwapMethodV5: ContractMethod {
    // MARK: Nested Types

    struct SwapDescription {
        let srcToken: Address
        let dstToken: Address
        let srcReceiver: Address
        let dstReceiver: Address
        let amount: BigUInt
        let minReturnAmount: BigUInt
        let flags: BigUInt
    }

    // MARK: Static Properties

    static let methodSignature = "swap(address,(address,address,address,address,uint256,uint256,uint256),bytes,bytes)"

    // MARK: Overridden Properties

    override var methodSignature: String { SwapMethodV5.methodSignature }

    override var arguments: [Any] {
        [caller, swapDescription, permit, data]
    }

    // MARK: Properties

    let caller: Address
    let swapDescription: SwapDescription
    let permit: Data
    let data: Data

    // MARK: Lifecycle

    init(caller: Address, swapDescription: SwapDescription, permit: Data, data: Data) {
        self.caller = caller
        self.swapDescription = swapDescription
        self.permit = permit
        self.data = data

        super.init()
    }
}
