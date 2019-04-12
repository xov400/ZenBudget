//
//  Fund.swift
//  ZenBudget
//
//  Created by Александр on 15.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class Fund: Decodable, Copyable {
    let id: UInt64
    let budgetID: UInt64
    let kindID: UInt64
    let fundName: String
    let amount: Double
    let extra: Category.Extra?
    let createdAt: String
    let updatedAt: String
    let deletedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case budgetID = "budget_id"
        case kindID = "type_id"
        case fundName = "name"
        case amount
        case extra
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }

    init(id: UInt64,
         budgetID: UInt64,
         kindID: UInt64,
         fundName: String,
         amount: Double,
         extra: Category.Extra?,
         createdAt: String,
         updatedAt: String,
         deletedAt: Date?) {
        self.id = id
        self.budgetID = budgetID
        self.kindID = kindID
        self.fundName = fundName
        self.amount = amount
        self.extra = extra
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UInt64.self, forKey: .id)
        budgetID = try container.decode(UInt64.self, forKey: .budgetID)
        kindID = try container.decode(UInt64.self, forKey: .kindID)
        fundName = try container.decode(String.self, forKey: .fundName)

        // Amount may be String or Double. I am cast it to Double always
        let stringAmountOrNil = try? container.decode(String.self, forKey: .amount)
        let doubleAmountOrNil = try? container.decode(Double.self, forKey: .amount)
        if let stringAmount = stringAmountOrNil, let amount = Double(stringAmount) {
            self.amount = amount
        } else if let amount = doubleAmountOrNil {
            self.amount = amount
        } else {
            throw DecodingError.dataCorruptedError(forType: Double.self, key: .amount, in: container)
        }

        extra = try container.decodeIfPresent(Category.Extra.self, forKey: .extra)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
    }

    func copy() -> Fund {
        return Fund(id: id,
                    budgetID: budgetID,
                    kindID: kindID,
                    fundName: fundName,
                    amount: amount,
                    extra: extra,
                    createdAt: createdAt,
                    updatedAt: updatedAt,
                    deletedAt: deletedAt)
    }
}
