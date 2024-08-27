//
//  UnparsedSwapMethodsFactoryV4.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class UnparsedSwapMethodsFactoryV4: IContractMethodsFactory {
    var methodID: Data { Data() }
    let methodIDs: [Data] = [
        ContractMethodHelper
            .methodID(signature: "fillOrderRFQ((uint256,address,address,address,address,uint256,uint256),bytes,uint256,uint256)"),
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
        ContractMethodHelper.methodID(signature: "clipperSwapToWithPermit(address,address,address,uint256,uint256,bytes)"),
        ContractMethodHelper.methodID(signature: "uniswapV3Swap(uint256,uint256,uint256[])"),
        ContractMethodHelper.methodID(signature: "uniswapV3SwapTo(address,uint256,uint256,uint256[])"),
        ContractMethodHelper.methodID(signature: "uniswapV3SwapToWithPermit(address,address,uint256,uint256,uint256[],bytes)"),
        ContractMethodHelper.methodID(signature: "unoswapWithPermit(address,uint256,uint256,bytes32[],bytes)"),
    ]

    func createMethod(inputArguments _: Data) throws -> ContractMethod {
        UnparsedSwapMethodV4()
    }
}
