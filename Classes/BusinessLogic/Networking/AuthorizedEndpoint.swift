//
//  AuthorizedEndpoint.swift
//  ZenBudget
//
//  Created by Александр on 26.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Alamofire

enum AuthorizedEndpoint: Endpoint {
    case endpoint(source: Endpoint, token: String?)

    func error(forStatusCode statusCode: Int, responseData: Data) -> Error? {
        switch self {
        case let .endpoint(source, _):
            return source.error(forStatusCode: statusCode, responseData: responseData)
        }
    }
}

extension AuthorizedEndpoint {
    var method: HTTPMethod {
        switch self {
        case .endpoint(let endpoint, _):
            return endpoint.method
        }
    }

    var path: String {
        switch self {
        case .endpoint(let endpoint, _):
            return endpoint.path
        }
    }

    var parameters: Parameters? {
        switch self {
        case .endpoint(let endpoint, _):
            return endpoint.parameters
        }
    }

    var httpHeaders: HTTPHeaders {
        switch self {
        case .endpoint(let endpoint, let token):
            var headers = endpoint.httpHeaders
            if let token = token {
                headers["Authorization"] = "Bearer \(token)"
            }
            return headers
        }
    }

    var baseURL: URL {
        switch self {
        case .endpoint(let endpoint, _):
            return endpoint.baseURL
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .endpoint(let endpoint, _):
            return endpoint.parameterEncoding
        }
    }
}
