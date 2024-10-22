//
//  UnoswapMethodV4.swift
//  OneInchKit
//
//  Created by Sun on 2021/7/6.
//

import Foundation

import BigInt
import EVMKit

// This method assumes that recipient is always the initiator of the transaction

class UnoswapMethodV4: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "unoswap(address,uint256,uint256,bytes32[])"

    // MARK: Overridden Properties

    override var methodSignature: String { UnoswapMethodV4.methodSignature }

    override var arguments: [Any] {
        [srcToken, amount, minReturn, params]
    }

    // MARK: Properties

    let srcToken: Address
    let amount: BigUInt
    let minReturn: BigUInt
    let params: [Data]

    // MARK: Lifecycle

    init(srcToken: Address, amount: BigUInt, minReturn: BigUInt, params: [Data]) {
        self.srcToken = srcToken
        self.amount = amount
        self.minReturn = minReturn
        self.params = params

        super.init()
    }
}
