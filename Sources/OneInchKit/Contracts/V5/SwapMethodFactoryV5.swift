//
//  SwapMethodFactoryV5.swift
//  OneInchKit
//
//  Created by Sun on 2021/7/6.
//

import Foundation

import BigInt
import EVMKit

class SwapMethodFactoryV5: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: SwapMethodV5.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        let argumentTypes: [Any] = [
            Address.self,
            ContractMethodHelper.StaticStructParameter([
                Address.self,
                Address.self,
                Address.self,
                Address.self,
                BigUInt.self,
                BigUInt.self,
                BigUInt.self,
            ]),
            Data.self,
            Data.self,
        ]
        let parsedArguments = ContractMethodHelper.decodeABI(
            inputArguments: inputArguments,
            argumentTypes: argumentTypes
        )

        guard
            let caller = parsedArguments[0] as? Address,
            let swapDescriptionArguments = parsedArguments[1] as? [Any],
            
            let srcToken = swapDescriptionArguments[0] as? Address,
            let dstToken = swapDescriptionArguments[1] as? Address,
            let srcReceiver = swapDescriptionArguments[2] as? Address,
            let dstReceiver = swapDescriptionArguments[3] as? Address,
            let amount = swapDescriptionArguments[4] as? BigUInt,
            let minReturnAmount = swapDescriptionArguments[5] as? BigUInt,
            let flags = swapDescriptionArguments[6] as? BigUInt,
            let permit = parsedArguments[2] as? Data,
            let data = parsedArguments[3] as? Data
        else {
            throw ContractMethodFactories.DecodeError.invalidABI
        }

        let swapDescription = SwapMethodV5.SwapDescription(
            srcToken: srcToken,
            dstToken: dstToken,
            srcReceiver: srcReceiver,
            dstReceiver: dstReceiver,
            amount: amount,
            minReturnAmount: minReturnAmount,
            flags: flags
        )

        return SwapMethodV5(caller: caller, swapDescription: swapDescription, permit: permit, data: data)
    }
}
