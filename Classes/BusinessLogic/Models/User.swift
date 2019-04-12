//
//  User.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class User: Decodable {

    let id: UInt64
    let email: String
    let updatedAt: Date
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case email
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }

    init(id: UInt64, email: String, updatedAt: Date, createdAt: Date) {
        self.id = id
        self.email = email
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UInt64.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        updatedAt = try container.decodeDate(.updatedAt, format: DateFormat.iso8601)
        createdAt = try container.decodeDate(.createdAt, format: DateFormat.iso8601)
    }
}
