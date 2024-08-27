//
//  OneInchMethodDecorator.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

// MARK: - OneInchMethodDecorator

class OneInchMethodDecorator {
    private let contractMethodFactories: OneInchContractMethodFactories

    init(contractMethodFactories: OneInchContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

// MARK: IMethodDecorator

extension OneInchMethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
