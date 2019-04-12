//
//  ErrorHandlingService.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

final class ErrorHandlingService: ErrorHandlingServiceProtocol {

    func handle(error: inout Error, response: DataResponse<Any>, endpoint: Endpoint) {
        if handleURLError(&error) {
            return
        }
        guard let urlResponse = response.response else {
            return
        }
        if handleError(&error, byStatusCode: urlResponse.statusCode) {
            return
        }
        if let data = response.data, let endpointError = endpoint.error(forStatusCode: urlResponse.statusCode, responseData: data) {
            error = endpointError
        }
    }

    private func handleURLError(_ error: inout Error) -> Bool {
        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            error = GeneralRequestError.notConnectedToInternet
            return true
        case NSURLErrorTimedOut:
            error = GeneralRequestError.timedOut
            return true
        default:
            return false
        }
    }

    private func handleError(_ error: inout Error, byStatusCode statusCode: Int) -> Bool {
        switch statusCode {
        case 401:
            error = GeneralRequestError.unauthorized
            return true
        default:
            return false
        }
    }
}
