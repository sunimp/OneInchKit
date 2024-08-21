//
//  TokenMapper.swift
//  OneInchKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

enum TokenMapper {
    static func token(map: [String: Any]) throws -> Token {
        guard let symbol = map["symbol"] as? String,
              let name = map["name"] as? String,
              let decimals = map["decimals"] as? Int,
              let address = map["address"] as? String
        else {
            throw ResponseError.invalidJson
        }

        return Token(symbol: symbol, name: name, decimals: decimals, address: address, logoUri: map["logoURI"] as? String ?? "")
    }
}

extension TokenMapper {
    public enum ResponseError: Error {
        case invalidJson
    }
}
