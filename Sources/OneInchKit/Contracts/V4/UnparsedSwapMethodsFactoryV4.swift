//
//  UnparsedSwapMethodsFactoryV4.swift
//  OneInchKit
//
//  Created by Sun on 2021/12/24.
//

import Foundation

import BigInt
import EVMKit

class UnparsedSwapMethodsFactoryV4: IContractMethodsFactory {
    // MARK: Properties

    let methodIDs: [Data] = [
        ContractMethodHelper
            .methodID(
                signature: "fillOrderRFQ((uint256,address,address,address,address,uint256,uint256),bytes,uint256,uint256)"
            ),
        ContractMethodHelper
            .methodID(
                signature: "fillOrderRFQTo((uint256,address,address,address,address,uint256,uint256),bytes,uint256,uint256,address)"
            ),
        ContractMethodHelper
            .methodID(
                signature: "fillOrderRFQToWithPermit((uint256,address,address,address,address,uint256,uint256),bytes,uint256,uint256,address,bytes)"
            ),
        ContractMethodHelper.methodID(signature: "clipperSwap(address,address,uint256,uint256)"),
        ContractMethodHelper.methodID(signature: "clipperSwapTo(address,address,address,uint256,uint256)"),
        ContractMethodHelper
            .methodID(signature: "clipperSwapToWithPermit(address,address,address,uint256,uint256,bytes)"),
        ContractMethodHelper.methodID(signature: "uniswapV3Swap(uint256,uint256,uint256[])"),
        ContractMethodHelper.methodID(signature: "uniswapV3SwapTo(address,uint256,uint256,uint256[])"),
        ContractMethodHelper
            .methodID(signature: "uniswapV3SwapToWithPermit(address,address,uint256,uint256,uint256[],bytes)"),
        ContractMethodHelper.methodID(signature: "unoswapWithPermit(address,uint256,uint256,bytes32[],bytes)"),
    ]

    // MARK: Computed Properties

    var methodID: Data { Data() }

    // MARK: Functions

    func createMethod(inputArguments _: Data) throws -> ContractMethod {
        UnparsedSwapMethodV4()
    }
}
