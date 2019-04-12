//
//  OperationsService.swift
//  ZenBudget
//
//  Created by Александр on 21.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire
import SwiftDate

final class OperationsService: OperationsServiceProtocol {

    private var sessionService: SessionServiceProtocol
    private var errorHandlingService: ErrorHandlingServiceProtocol

    private var pagination = Pagination(pageNumber: 1, elementsPerPage: 10, isLastPage: false)

    init(sessionService: SessionServiceProtocol, errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        self.errorHandlingService = errorHandlingService
    }

    func fetchOperations(initially: Bool,
                         withTrashedCategories: Bool,
                         success: @escaping (OperationsDataResponse, Bool) -> Void,
                         failure: @escaping (Error) -> Void) {
        if initially {
            pagination = Pagination(pageNumber: 1, elementsPerPage: 10, isLastPage: false)
        }
        let endpoint = OperationsEndpoint.fetchOperations(page: pagination.pageNumber,
                                                          perPage: pagination.elementsPerPage,
                                                          withTrashedCategories: withTrashedCategories)
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let operationsDataResponse = try JSONDecoder().decode(OperationsDataResponse.self, from: data)
                        self.pagination.isLastPage = operationsDataResponse.lastPage == operationsDataResponse.currentPage
                        self.pagination.pageNumber = operationsDataResponse.currentPage + 1
                        success(operationsDataResponse, self.pagination.isLastPage)
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

    func addOperation(parameters: AddOperationParameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = OperationsEndpoint.addOperation(parameters: parameters)
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if response.data != nil {
                    do {
                        success("Операция успешно добавлена")
                    }
                }
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }
}
