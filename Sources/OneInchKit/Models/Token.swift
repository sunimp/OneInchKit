//
//  Token.swift
//
//  Created by Sun on 2021/6/9.
//

import Foundation

// MARK: - Token

public struct Token {
    // MARK: Properties

    public let symbol: String
    public let name: String
    public let decimals: Int
    public let address: String
    public let logoUri: String

    // MARK: Lifecycle

    public init(symbol: String, name: String, decimals: Int, address: String, logoUri: String) {
        self.symbol = symbol
        self.name = name
        self.decimals = decimals
        self.address = address
        self.logoUri = logoUri
    }
}

// MARK: CustomStringConvertible

extension Token: CustomStringConvertible {
    public var description: String {
        "[symbol: \(symbol); name: \(name); decimals: \(decimals.description); decimals: \(address)]"
    }
}
