//
//  CategoriesDataResponse.swift
//  ZenBudget
//
//  Created by Александр on 14.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class CategoriesDataResponse: Decodable {
    let count: UInt
    let perPage: UInt
    let currentPage: UInt
    let lastPage: UInt
    let fromElem: UInt
    let toElem: UInt

    let firstPageURL: URL?
    let lastPageURL: URL?
    let nextPageURL: URL?
    let prevPageURL: URL?

    let path: String
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case count = "total"
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case firstPageURL = "first_page_url"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case prevPageURL = "prev_page_url"
        case path
        case fromElem = "from"
        case toElem = "to"
        case categories = "data"
    }

    subscript(categoryName: String) -> Category? {
        return categories.first { category -> Bool in
            return category.name == categoryName
        }
    }

    subscript(index: UInt64) -> Category? {
        return categories.first { category -> Bool in
            category.id == index
        }
    }
}
