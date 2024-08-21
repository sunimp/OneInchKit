//
//  OneInchContractMethodFactories.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class OneInchContractMethodFactories: ContractMethodFactories {
    static let shared = OneInchContractMethodFactories()

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
