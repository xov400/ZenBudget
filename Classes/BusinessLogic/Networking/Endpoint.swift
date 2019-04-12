//
//  Endpoint.swift
//  ZenBudget
//
//  Created by Александр on 26.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

protocol Endpoint: EndpointError {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
    var requiresAuthorization: Bool { get }
    var httpHeaders: HTTPHeaders { get }
}

extension Endpoint {

    var baseURL: URL {
        return URL(string: "https://dev.api.zenbudget.ronasit.com/")!
    }

    var parameters: Parameters? {
        return nil
    }

    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var url: URL {
        return baseURL.appendingPathComponent(path)
    }

    var requiresAuthorization: Bool {
        return true
    }
}

protocol RequestHeader {
    var key: String { get }
    var value: String { get }
}

protocol EndpointError {
    func error(forStatusCode statusCode: Int, responseData: Data) -> Error?
}
