//
//  ProfileEndpoint.swift
//  ZenBudget
//
//  Created by Александр on 1.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

enum ProfileEndpoint {
    case fetchProfile
}

extension ProfileEndpoint: Endpoint {

    var path: String {
        switch self {
        case .fetchProfile:
            return "user/me"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchProfile:
            return .get
        }
    }

    var httpHeaders: HTTPHeaders {
        switch self {
        case .fetchProfile:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}

extension ProfileEndpoint: EndpointError {

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
