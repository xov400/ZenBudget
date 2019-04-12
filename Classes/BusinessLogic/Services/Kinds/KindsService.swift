//
//  KindService.swift
//  ZenBudget
//
//  Created by Александр on 19.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire
import SwiftDate

final class KindsService: KindsServiceProtocol {

    private static var shared: KindsService?
    private var sessionService: SessionServiceProtocol
    private var errorHandlingService: ErrorHandlingServiceProtocol

    var kindsDataResponse: KindsDataResponse?

    private init(sessionService: SessionServiceProtocol, errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        self.errorHandlingService = errorHandlingService
    }

    static func shared(sessionService: SessionServiceProtocol, errorHandlingService: ErrorHandlingServiceProtocol) -> KindsService {
        if shared == nil {
            shared = KindsService(sessionService: sessionService, errorHandlingService: errorHandlingService)
        }
        return shared!
    }

    func fetchKindsService(success: @escaping (KindsDataResponse) -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = KindsEndpoint.fetchKinds
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let kindsDataResponse = try JSONDecoder().decode(KindsDataResponse.self, from: data)
                        self.kindsDataResponse = kindsDataResponse
                        success(kindsDataResponse)
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
