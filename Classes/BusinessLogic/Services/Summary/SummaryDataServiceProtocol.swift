//
//  GetSummaryDataServiseProtocol.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

protocol HasSummaryDataService {
    var summaryDataService: SummaryDataServiceProtocol { get }
}

protocol SummaryDataServiceProtocol {
    func fetchSummaryData(success: @escaping (SummaryDataResponse) -> Void, failure: @escaping (Error) -> Void)
}
