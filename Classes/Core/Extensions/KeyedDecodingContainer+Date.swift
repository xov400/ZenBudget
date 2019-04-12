//
//  KeyedDecodingContainer+Date.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {

    func decodeDate(_ key: KeyedDecodingContainer.Key, format: DateFormat) throws -> Date {
        let dateString = try decode(String.self, forKey: key)
        let dateFormatter = DateFormatter(format: format)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dateCorruptedError(forKey: key, in: self)
        }
    }

    func decodeDateIfPresent(_ key: KeyedDecodingContainer.Key, format: DateFormat) throws -> Date? {
        guard let dateString = try decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        let dateFormatter = DateFormatter(format: format)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dateCorruptedError(forKey: key, in: self)
        }
    }
}
