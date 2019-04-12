//
//  AddOperationParameters.swift
//  ZenBudget
//
//  Created by Александр on 22.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
final class AddOperationParameters {

    let name: String
    let categoryID: UInt64
    let categoryLoanID: UInt64?
    let amount: Double

    init(operationName: String, categoryID: UInt64, categoryLoanID: UInt64?, amount: Double) {
        self.name = operationName
        self.categoryID = categoryID
        self.categoryLoanID = categoryLoanID
        self.amount = amount
    }
}
