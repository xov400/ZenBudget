//
//  CategoriesServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 17.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

protocol HasCategoriesService {
    var categoriesService: CategoriesServiceProtocol { get }
}

protocol CategoriesServiceProtocol {

    var coloredCategories: [ColoredCategory] { get }

    func fetchCategories(parameters: FetchCategoriesParameters,
                         success: @escaping (CategoriesDataResponse) -> Void,
                         failure: @escaping (Error) -> Void)

    func addCategory(parameters: AddCategoryParameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void)

    func editCategory(categoryID: UInt64,
                      parameters: EditCategoryParameters,
                      success: @escaping (String) -> Void,
                      failure: @escaping (Error) -> Void)

    func deleteCategory(categoryID: UInt64, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void)
}
