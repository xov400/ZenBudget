//
//  CategoriesService.swift
//  ZenBudget
//
//  Created by Александр on 17.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire
import SwiftDate

final class CategoriesService: CategoriesServiceProtocol {

    private static var shared: CategoriesService?
    private var sessionService: SessionServiceProtocol
    private var errorHandlingService: ErrorHandlingServiceProtocol

    var coloredCategories: [ColoredCategory] = []

    static func shared(sessionService: SessionServiceProtocol,
                       errorHandlingService: ErrorHandlingServiceProtocol) -> CategoriesService {
        if shared == nil {
            shared = CategoriesService(sessionService: sessionService, errorHandlingService: errorHandlingService)
        }
        return shared!
    }

    private init(sessionService: SessionServiceProtocol, errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        self.errorHandlingService = errorHandlingService
    }

    func fetchCategories(parameters: FetchCategoriesParameters,
                         success: @escaping (CategoriesDataResponse) -> Void,
                         failure: @escaping (Error) -> Void) {
        let endpoint = CategoriesEndpoint.fetchCategories(parameters: parameters)
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let categoriesDataResponse = try JSONDecoder().decode(CategoriesDataResponse.self, from: data)
                        let colorService: ColorServiceProtocol = ColorService()
                        self.coloredCategories = categoriesDataResponse.categories.map({ category -> ColoredCategory in
                            return ColoredCategory(category: category, color: colorService.coloring())
                        })
                        success(categoriesDataResponse)
                    } catch {
                        failure(error)
                    }
                }
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }

    func addCategory(parameters: AddCategoryParameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = CategoriesEndpoint.addCategory(parameters: parameters)
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if response.data != nil {
                    do {
                        success("Категория успешно добавлена")
                    }
                }
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }

    func editCategory(categoryID: UInt64,
                      parameters: EditCategoryParameters,
                      success: @escaping (String) -> Void,
                      failure: @escaping (Error) -> Void) {
        let endpoint = CategoriesEndpoint.editCategory(categoryID: categoryID, parameters: parameters)
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if response.data != nil {
                    do {
                        success("Категория успешно изменена")
                    }
                }
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }

    func deleteCategory(categoryID: UInt64, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = CategoriesEndpoint.deleteCategory(categoryID: categoryID)
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if response.data != nil {
                    do {
                        success("Категория удалена")
                    }
                }
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }
}
