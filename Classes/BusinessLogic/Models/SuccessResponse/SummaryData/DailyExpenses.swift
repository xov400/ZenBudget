//
//  DailyExpenses.swift
//  ZenBudget
//
//  Created by Александр on 15.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class DailyExpenses: Decodable, Copyable {
    let amount: Double
    let abnormalPercent: Double

    enum CodingKeys: String, CodingKey {
        case amount
        case abnormalPercent = "abnormal_percent"
    }

    init(amount: Double, abnormalPercent: Double) {
        self.amount = amount
        self.abnormalPercent = abnormalPercent
    }

    func copy() -> DailyExpenses {
        return DailyExpenses(amount: amount, abnormalPercent: amount)
    }
}
