//
//  OneInchContractMethodFactories.swift
//  OneInchKit
//
//  Created by Sun on 2021/7/6.
//

import Foundation

import EVMKit

class OneInchContractMethodFactories: ContractMethodFactories {
    // MARK: Static Properties

    static let shared = OneInchContractMethodFactories()

    // MARK: Lifecycle

    override init() {
        super.init()
        register(factories: [
            UnoswapMethodFactoryV4(),
            SwapMethodFactoryV4(),
            UnparsedSwapMethodsFactoryV4(),
            UnoswapMethodFactoryV5(),
            SwapMethodFactoryV5(),
            UnparsedSwapMethodsFactoryV5(),
        ])
    }
}
