//
//  OperationsServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 21.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

protocol HasOperationsService {
    var operationsService: OperationsServiceProtocol { get }
}

protocol OperationsServiceProtocol {

    func fetchOperations(initially: Bool,
                         withTrashedCategories: Bool,
                         success: @escaping (OperationsDataResponse, Bool) -> Void,
                         failure: @escaping (Error) -> Void)

    func addOperation(parameters: AddOperationParameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void)
}
