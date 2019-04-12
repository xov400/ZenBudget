//
//  Category.swift
//  ZenBudget
//
//  Created by Александр on 15.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class Category {

    let id: UInt64
    let name: String
    let budgetID: UInt64
    let kindID: UInt64
    var kind: Category.Kind?
    let amount: Double
    let extra: Category.Extra?
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?

    final class Kind {
        let id: UInt64
        let name: String
        let description: String
        let isCategoryCreatable: Bool
        let isCategoryEditable: Bool
        let isCategoryDeletable: Bool

        init(id: UInt64,
             name: String,
             description: String,
             isCategoryCreatable: Bool,
             isCategoryEditable: Bool,
             isCategoryDeletable: Bool) {
            self.id = id
            self.name = name
            self.description = description
            self.isCategoryCreatable = isCategoryCreatable
            self.isCategoryEditable = isCategoryEditable
            self.isCategoryDeletable = isCategoryDeletable
        }
    }

    final class Extra {
        var goal: Double?
        var sum: Double?
        var remainingAmount: Double?

        init(goal: Double?, sum: Double?, remainingAmount: Double?) {
            self.goal = goal
            self.sum = sum
            self.remainingAmount = remainingAmount
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UInt64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        budgetID = try container.decode(UInt64.self, forKey: .budgetID)
        kindID = try container.decode(UInt64.self, forKey: .kindID)
        kind = try container.decodeIfPresent(Category.Kind.self, forKey: .kind)

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
        createdAt = try container.decodeDate(.createdAt, format: DateFormat.iso8601)
        updatedAt = try container.decodeDate(.updatedAt, format: DateFormat.iso8601)
        deletedAt = try container.decodeDateIfPresent(.deletedAt, format: DateFormat.iso8601)
    }

    init(id: UInt64,
         name: String,
         budgetID: UInt64,
         kindID: UInt64,
         kind: Category.Kind?,
         amount: Double,
         extra: Category.Extra?,
         createdAt: Date,
         updatedAt: Date,
         deletedAt: Date?) {
        self.id = id
        self.name = name
        self.budgetID = budgetID
        self.kindID = kindID
        self.kind = kind
        self.amount = amount
        self.extra = extra
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}

extension Category: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case budgetID = "budget_id"
        case kindID = "type_id"
        case kind = "type"
        case amount
        case extra
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

extension Category: Copyable {

    func copy() -> Category {
        return Category(id: id,
                        name: name,
                        budgetID: budgetID,
                        kindID: kindID,
                        kind: kind,
                        amount: amount,
                        extra: extra,
                        createdAt: createdAt,
                        updatedAt: updatedAt,
                        deletedAt: deletedAt)
    }
}

extension Category.Kind: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case isCategoryCreatable = "is_category_creatable"
        case isCategoryEditable = "is_category_editable"
        case isCategoryDeletable = "is_category_deletable"
    }
}

extension Category.Kind: Copyable {

    func copy() -> Category.Kind {
        return Category.Kind(id: id,
                    name: name,
                    description: description,
                    isCategoryCreatable: isCategoryCreatable,
                    isCategoryEditable: isCategoryEditable,
                    isCategoryDeletable: isCategoryDeletable)
    }
}

extension Category.Extra: Decodable {
    enum CodingKeys: String, CodingKey {
        case goal
        case sum
        case remainingAmount = "remaining_amount"
    }
}

extension Category.Extra: Copyable {

    func copy() -> Category.Extra {
        return Category.Extra(goal: goal, sum: sum, remainingAmount: remainingAmount)
    }
}
