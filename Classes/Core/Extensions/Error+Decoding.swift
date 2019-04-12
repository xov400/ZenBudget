//
//  Error+Decoding.swift
//  ZenBudget
//
//  Created by Александр on 28.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

extension Error {

    static func error<T>(from data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
