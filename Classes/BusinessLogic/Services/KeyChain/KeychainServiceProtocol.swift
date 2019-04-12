//
//  KeychainServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import KeychainSwift

protocol HasKeychainService {
    var keychainService: KeychainServiceProtocol { get }
}

protocol KeychainServiceProtocol {
    subscript(key: String) -> String? { get set }
}
