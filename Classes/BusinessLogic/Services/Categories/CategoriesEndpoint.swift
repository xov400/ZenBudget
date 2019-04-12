//
//  CategoriesEndpoint.swift
//  ZenBudget
//
//  Created by Александр on 17.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

enum CategoriesEndpoint {
    case fetchCategories(parameters: FetchCategoriesParameters)
    case addCategory(parameters: AddCategoryParameters)
    case editCategory(categoryID: UInt64, parameters: EditCategoryParameters)
    case deleteCategory(categoryID: UInt64)
}

extension CategoriesEndpoint: Endpoint {

    var path: String {
        switch self {
        case .fetchCategories:
            return "categories"
        case .addCategory:
            return "categories"
        case .editCategory(let categoryID, _):
            return "categories/\(categoryID)"
        case .deleteCategory(let categoryID):
            return "categories/\(categoryID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchCategories:
            return .get
        case .addCategory:
            return .post
        case .editCategory:
            return .put
        case .deleteCategory:
            return .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetchCategories:
            return nil
        case .addCategory(let parameters):
            return ["name": parameters.name,
                    "type_id": parameters.typeID,
                    "amount": parameters.amount,
                    "goal": parameters.goal]
        case .editCategory(_, let parameters):
            return ["amount": parameters.amount,
                    "name": parameters.name,
                    "goal": parameters.goal]
        case .deleteCategory:
            return nil
        }
    }

    var httpHeaders: HTTPHeaders {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}

extension CategoriesEndpoint: EndpointError {

    func error(forStatusCode statusCode: Int, responseData: Data) -> Error? {
        if let error: FieldsCategoryError = try? FieldsCategoryError.error(from: responseData) {
            return error
        }
        if let error: ResourcesCategoryError = try? ResourcesCategoryError.error(from: responseData) {
            return error
        }
        switch statusCode {
        default:
            return nil
        }
    }
}
