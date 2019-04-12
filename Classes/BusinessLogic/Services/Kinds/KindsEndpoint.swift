//
//  KindsEndpoint.swift
//  ZenBudget
//
//  Created by Александр on 19.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Alamofire

enum KindsEndpoint {
    case fetchKinds
}

extension KindsEndpoint: Endpoint {

    var path: String {
        switch self {
        case .fetchKinds:
            return "types"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchKinds:
            return .get
        }
    }

    var httpHeaders: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
}

extension KindsEndpoint: EndpointError {

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
