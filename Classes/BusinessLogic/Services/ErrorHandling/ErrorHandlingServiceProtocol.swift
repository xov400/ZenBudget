//
//  ErrorHandlingServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

protocol HasErrorHandlingService {
    var errorHandlingService: ErrorHandlingServiceProtocol { get }
}

protocol ErrorHandlingServiceProtocol {
    func handle(error: inout Error, response: DataResponse<Any>, endpoint: Endpoint)
}
