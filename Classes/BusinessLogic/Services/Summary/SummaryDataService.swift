//
//  GetSummaryDataServise.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire
import SwiftDate

final class SummaryDataService: SummaryDataServiceProtocol {

    private var sessionService: SessionServiceProtocol
    private var errorHandlingService: ErrorHandlingServiceProtocol

    init(sessionService: SessionServiceProtocol, errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        self.errorHandlingService = errorHandlingService
    }

    func fetchSummaryData(success: @escaping (SummaryDataResponse) -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = SummaryDataEnpoint.fetchSummaryDataEndpoint
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let summaryDataResponse = try JSONDecoder().decode(SummaryDataResponse.self, from: data)
                        success(summaryDataResponse)
                    } catch {
                        failure(error)
                    }
                }
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }
}
