//
//  Spender.swift
//
//  Created by Sun on 2021/6/9.
//

import Foundation

import EVMKit

struct Spender {
    // MARK: Properties

    let address: Address

    // MARK: Lifecycle

    init(address: Address) {
        self.address = address
    }
}
