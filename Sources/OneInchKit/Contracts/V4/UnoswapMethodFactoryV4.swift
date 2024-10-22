//
//  UnoswapMethodFactoryV4.swift
//  OneInchKit
//
//  Created by Sun on 2021/7/6.
//

import Foundation

import BigInt
import EVMKit

class UnoswapMethodFactoryV4: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: UnoswapMethodV4.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let parsedArguments = ContractMethodHelper.decodeABI(
            inputArguments: inputArguments,
            argumentTypes: [Address.self, BigUInt.self, BigUInt.self, [Data].self]
        )
        guard
            let srcToken = parsedArguments[0] as? Address,
            let amount = parsedArguments[1] as? BigUInt,
            let minReturn = parsedArguments[2] as? BigUInt,
            let params = parsedArguments[3] as? [Data]
        else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        return UnoswapMethodV4(srcToken: srcToken, amount: amount, minReturn: minReturn, params: params)
    }
}
