//
//  DataRequest+Endpoint.swift
//  ZenBudget
//
//  Created by Александр on 1.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {

    static func request(endpoint: Endpoint) -> DataRequest {
        let request = Alamofire.request(endpoint.url,
                                        method: endpoint.method,
                                        parameters: endpoint.parameters,
                                        encoding: endpoint.parameterEncoding,
                                        headers: endpoint.httpHeaders)
        request.validate()
        return request
    }
}
