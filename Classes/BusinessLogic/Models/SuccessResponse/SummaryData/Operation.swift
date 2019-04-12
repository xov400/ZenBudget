//
//  Operation.swift
//  ZenBudget
//
//  Created by Александр on 15.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class Operation: Decodable, Copyable {
    let id: UInt64
    let operationName: String?
    let amount: Double
    let categoryID: UInt64
    let category: Category?
    let parentOperationID: UInt64?
    var createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case operationName = "comment"
        case amount
        case categoryID = "category_id"
        case category
        case parentOperationID = "parent_operation_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UInt64.self, forKey: .id)
        operationName = try container.decodeIfPresent(String.self, forKey: .operationName)

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

        categoryID = try container.decode(UInt64.self, forKey: .categoryID)
        category = try container.decodeIfPresent(Category.self, forKey: .category)
        parentOperationID = try container.decodeIfPresent(UInt64.self, forKey: .parentOperationID)
        createdAt = try container.decodeDate(.createdAt, format: DateFormat.iso8601)
        updatedAt = try container.decodeDate(.updatedAt, format: DateFormat.iso8601)
        deletedAt = try container.decodeDateIfPresent(.deletedAt, format: DateFormat.iso8601)
    }

    init(id: UInt64,
         operationName: String?,
         amount: Double,
         categoryID: UInt64,
         category: Category?,
         parentOperationID: UInt64?,
         createdAt: Date,
         updatedAt: Date,
         deletedAt: Date?) {
        self.id = id
        self.operationName = operationName
        self.amount = amount
        self.categoryID = categoryID
        self.category = category
        self.parentOperationID = parentOperationID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }

    func copy() -> Operation {
        return Operation(id: id,
                         operationName: operationName,
                         amount: amount,
                         categoryID: categoryID,
                         category: category,
                         parentOperationID: parentOperationID,
                         createdAt: createdAt,
                         updatedAt: updatedAt,
                         deletedAt: deletedAt)
    }
}
