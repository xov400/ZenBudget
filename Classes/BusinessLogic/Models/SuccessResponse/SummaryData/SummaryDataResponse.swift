//
//  SummaryDataResponse.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class SummaryDataResponse: Decodable, Copyable {
    let dailyExpenses: DailyExpenses
    let funds: [Fund]
    var operations: [Operation]

    enum CodingKeys: String, CodingKey {
        case dailyExpenses = "daily_expenses"
        case funds
        case operations
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dailyExpenses = try container.decode(DailyExpenses.self, forKey: .dailyExpenses)
        funds = try container.decode([Fund].self, forKey: .funds)
        operations = try container.decode([Operation].self, forKey: .operations)
    }

    init(dailyExpenses: DailyExpenses, funds: [Fund], operations: [Operation]) {
        self.dailyExpenses = dailyExpenses
        self.funds = funds
        self.operations = operations
    }

    func copy() -> SummaryDataResponse {
        return SummaryDataResponse(dailyExpenses: dailyExpenses.copy(),
                                   funds: funds.copy(),
                                   operations: operations.copy())
    }
}
