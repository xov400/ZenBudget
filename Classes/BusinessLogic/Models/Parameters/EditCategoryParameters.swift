//
//  EditCategoryParameters.swift
//  ZenBudget
//
//  Created by Александр on 21.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class EditCategoryParameters {
    let name: String
    let amount: Double
    let goal: Double

    init(name: String, amount: Double, goal: Double) {
        self.name = name
        self.amount = amount
        self.goal = goal
    }
}
