//
//  OneInchMethodDecorator.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class OneInchMethodDecorator {
    private let contractMethodFactories: OneInchContractMethodFactories

    init(contractMethodFactories: OneInchContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

extension OneInchMethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
