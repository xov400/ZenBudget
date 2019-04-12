//
//  OperationsEndpoint.swift
//  ZenBudget
//
//  Created by Александр on 21.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

enum OperationsEndpoint {
    case fetchOperations(page: Int, perPage: Int, withTrashedCategories: Bool)
    case addOperation(parameters: AddOperationParameters)
    case editOperation()
    case deleteOperation()
}

extension OperationsEndpoint: Endpoint {

    var path: String {
        return "operations"
    }

    var method: HTTPMethod {
        switch self {
        case .fetchOperations:
            return .get
        case .addOperation:
            return .post
        case .editOperation:
            return .put
        case .deleteOperation:
            return .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .fetchOperations(page, perPage, withTrashedCategories):
            return [
                "page": page,
                "per_page": perPage,
                "withTrashedCategories": withTrashedCategories
            ]
        case .addOperation(let parameters):
            var parametersDictionary: Parameters = ["comment": parameters.name,
                                                    "category_id": parameters.categoryID,
                                                    "amount": parameters.amount]
            if let categoryLoanID = parameters.categoryLoanID {
                parametersDictionary["category_loan_id"] = categoryLoanID
            }
            return parametersDictionary
        case .editOperation:
            return nil
        case .deleteOperation:
            return nil
        }
    }

    var httpHeaders: HTTPHeaders {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}

extension OperationsEndpoint: EndpointError {

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
