//
//  AddCategoryParameters.swift
//  ZenBudget
//
//  Created by Александр on 20.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class AddCategoryParameters {
    let name: String
    let typeID: UInt64
    let amount: Double
    let goal: Double

    init(categoryName: String, kindID: UInt64, amount: Double, goal: Double) {
        self.name = categoryName
        self.typeID = kindID
        self.amount = amount
        self.goal = goal
    }
}
