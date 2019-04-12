//
//  FieldsCategoryError.swift
//  ZenBudget
//
//  Created by Александр on 20.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class FieldsCategoryError: Error, Decodable {
    let message: String
    let errors: FieldsCategoryError.FieldErrors

    class FieldErrors: Decodable {
        let name: [String]?
        let typeID: [String]?
        let amount: [String]?

        // swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case name
            case typeID = "type_id"
            case amount
        }
    }
}
