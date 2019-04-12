//
//  KeychainService.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import KeychainSwift

final class KeychainService: KeychainServiceProtocol {

    private var keychain = KeychainSwift()

    subscript(key: String) -> String? {
        get {
            return keychain.get("ZenBudget_" + key)
        }
        set(newValue) {
            if let value = newValue {
                keychain.set(value, forKey: "ZenBudget_" + key)
            } else {
                keychain.delete("ZenBudget_" + key)
            }
        }
    }
}
