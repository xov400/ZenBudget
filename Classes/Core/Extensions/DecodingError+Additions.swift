//
//  DecodingError+Editions.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

extension DecodingError {

    static var dataCorrupted: DecodingError {
        return .dataCorrupted(Context(codingPath: [], debugDescription: "Data corrupted"))
    }

    static func dateCorruptedError<C>(forKey key: C.Key, in container: C) -> DecodingError where C: KeyedDecodingContainerProtocol {
        return .dataCorruptedError(forKey: key, in: container, debugDescription: "Date string does not match format expected by formatter.")
    }

    static func dataCorruptedError<C>(forType type: Any.Type, key: C.Key, in container: C) -> DecodingError where C: KeyedDecodingContainerProtocol {
        return .dataCorruptedError(forKey: key, in: container, debugDescription: "Unable to map data for type \(String(describing: type)) key \(key)")
    }
}
