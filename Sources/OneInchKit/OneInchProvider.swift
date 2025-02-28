//
//  OneInchProvider.swift
//  OneInchKit
//
//  Created by Sun on 2021/6/9.
//

import Foundation

import Alamofire
import BigInt
import EVMKit
import SWToolKit

// MARK: - OneInchProvider

class OneInchProvider {
    // MARK: Static Properties

    private static let notEnoughEthErrors = [
        "Try to leave the buffer of ETH for gas",
        "you may not have enough ETH balance for gas fee",
        "Not enough ETH balance",
        "insufficient funds for transfer",
    ]

    // MARK: Properties

    private var headers: HTTPHeaders?

    // MARK: Computed Properties

    private var url: String { "https://api.1inch.dev/swap/" }

    // MARK: Lifecycle

    init(apiKey: String) {
        headers = HTTPHeaders([HTTPHeader.authorization(bearerToken: apiKey)])
    }

    // MARK: Static Functions

    private static func notEnoughErrorContains(in message: String) -> Bool {
        for error in notEnoughEthErrors {
            if message.contains(error) {
                return true
            }
        }

        return false
    }

    // MARK: Functions

    private func params(dictionary: [String: Any?]) -> [String: Any] {
        var result = [String: Any]()

        for (key, value) in dictionary {
            if let value {
                result[key] = value
            }
        }

        return result
    }
}

extension OneInchProvider {
    func quote(
        networkManager: NetworkManager,
        chain: Chain,
        fromToken: Address,
        toToken: Address,
        amount: BigUInt,
        fee: Decimal? = nil,
        protocols: String? = nil,
        gasPrice: GasPrice? = nil,
        complexityLevel: Int? = nil,
        connectorTokens: String? = nil,
        gasLimit: Int? = nil,
        mainRouteParts: Int? = nil,
        parts: Int? = nil,
        includeTokensInfo: Bool = true,
        includeProtocols: Bool = true,
        includeGas: Bool = true
    ) async throws
        -> Quote {
        var parameters = params(
            dictionary:
            [
                "src": fromToken,
                "dst": toToken,
                "amount": amount.description,
                "protocols": protocols,
                "connectorTokens": connectorTokens,
                "complexityLevel": complexityLevel,
                "gasLimit": gasLimit,
                "mainRouteParts": mainRouteParts,
                "parts": parts,
                "includeTokensInfo": includeTokensInfo,
                "includeProtocols": includeProtocols,
                "includeGas": includeGas,
                "fee": fee,
            ]
        )

        switch gasPrice {
        case let .legacy(legacyGasPrice):
            parameters["gasPrice"] = legacyGasPrice

        case let .eip1559(maxFeePerGas, maxPriorityFeePerGas):
            parameters["maxFeePerGas"] = maxFeePerGas
            parameters["maxPriorityFeePerGas"] = maxPriorityFeePerGas

        case .none: ()
        }

        do {
            let json = try await networkManager.fetchJson(
                url: url + "v5.2/\(chain.id)/quote",
                method: .get,
                parameters: parameters,
                headers: headers,
                responseCacherBehavior: .doNotCache
            )

            guard let map = json as? [String: Any] else {
                throw ResponseError.invalidJson
            }

            return try QuoteMapper.quote(map: map)
        } catch {
            if
                let responseError = error as? NetworkManager.ResponseError,
                let dictionary = responseError.json as? [String: Any],
                let message = dictionary["message"] as? String,
                message.contains("insufficient liquidity") {
                throw Kit.QuoteError.insufficientLiquidity
            }

            throw error
        }
    }

    func swap(
        networkManager: NetworkManager,
        chain: Chain,
        fromToken: String,
        toToken: String,
        amount: BigUInt,
        fromAddress: String,
        slippage: Decimal,
        referrer: String? = nil,
        fee: Decimal? = nil,
        protocols: String? = nil,
        recipient: String? = nil,
        gasPrice: GasPrice? = nil,
        burnChi: Bool? = nil,
        complexityLevel: Int? = nil,
        connectorTokens: String? = nil,
        allowPartialFill: Bool? = nil,
        gasLimit: Int? = nil,
        mainRouteParts: Int? = nil,
        parts: Int? = nil,
        includeTokensInfo: Bool = true,
        includeProtocols: Bool = true,
        includeGas: Bool = true
    ) async throws
        -> Swap {
        var parameters = params(
            dictionary:
            [
                "src": fromToken,
                "dst": toToken,
                "amount": amount.description,
                "from": fromAddress,
                "slippage": slippage,
                "referrer": referrer,
                "protocols": protocols,
                "receiver": recipient,
                "burnChi": burnChi,
                "complexityLevel": complexityLevel,
                "connectorTokens": connectorTokens,
                "allowPartialFill": allowPartialFill,
                "gasLimit": gasLimit,
                "mainRouteParts": mainRouteParts,
                "parts": parts,
                "includeTokensInfo": includeTokensInfo,
                "includeProtocols": includeProtocols,
                "includeGas": includeGas,
                "fee": fee,
            ]
        )

        switch gasPrice {
        case let .legacy(legacyGasPrice):
            parameters["gasPrice"] = legacyGasPrice

        case let .eip1559(maxFeePerGas, maxPriorityFeePerGas):
            parameters["maxFeePerGas"] = maxFeePerGas
            parameters["maxPriorityFeePerGas"] = maxPriorityFeePerGas

        case .none: ()
        }
        do {
            let json = try await networkManager.fetchJson(
                url: url + "v5.2/\(chain.id)/swap",
                method: .get,
                parameters: parameters,
                headers: headers,
                responseCacherBehavior: .doNotCache
            )

            guard let map = json as? [String: Any] else {
                throw ResponseError.invalidJson
            }

            return try SwapMapper.swap(map: map)
        } catch {
            if
                let responseError = error as? NetworkManager.ResponseError,
                let dictionary = responseError.json as? [String: Any],
                let message = dictionary["message"] as? String {
                if Self.notEnoughErrorContains(in: message) {
                    throw Kit.SwapError.notEnough
                } else if message.contains("cannot estimate") {
                    throw Kit.SwapError.cannotEstimate
                }
            }

            throw error
        }
    }
}

// MARK: OneInchProvider.ResponseError

extension OneInchProvider {
    public enum ResponseError: Error {
        case invalidJson
    }
}
