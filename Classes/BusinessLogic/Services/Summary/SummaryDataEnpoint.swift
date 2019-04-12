//
//  SummaryDataEnpoint.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

enum SummaryDataEnpoint {
    case fetchSummaryDataEndpoint
}

extension SummaryDataEnpoint: Endpoint {

    var path: String {
        switch self {
        case .fetchSummaryDataEndpoint:
            return "summary"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchSummaryDataEndpoint:
            return .get
        }
    }

    var httpHeaders: HTTPHeaders {
        switch self {
        case .fetchSummaryDataEndpoint:
            return ["Content-Type": "application/json"]
        }
    }
}

extension SummaryDataEnpoint: EndpointError {

    func error(forStatusCode statusCode: Int, responseData: Data) -> Error? {
        if let error: AuthEndpointError = try? AuthEndpointError.error(from: responseData) {
            return error
        }
        switch statusCode {
        default:
            return nil
        }
    }
}
