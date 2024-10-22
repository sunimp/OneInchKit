//
//  OneInchMethodDecorator.swift
//  OneInchKit
//
//  Created by Sun on 2022/4/7.
//

import Foundation

import EVMKit

// MARK: - OneInchMethodDecorator

class OneInchMethodDecorator {
    // MARK: Properties

    private let contractMethodFactories: OneInchContractMethodFactories

    // MARK: Lifecycle

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
