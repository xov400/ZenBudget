//
//  TypesDataResponse.swift
//  ZenBudget
//
//  Created by Александр on 13.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class KindsDataResponse: Decodable {
    let total: UInt
    let perPage: UInt
    let currentPage: UInt
    let lastPage: UInt
    let firstPageUrl: UInt?
    let lastPageUrl: UInt?
    let nextPageUrl: UInt?
    let prevPageUrl: UInt?
    let path: String
    let from: UInt
    let toCategory: UInt
    var kinds: [Category.Kind]

    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case firstPageUrl = "first_page_url"
        case lastPageUrl = "last_page_url"
        case nextPageUrl = "next_page_url"
        case prevPageUrl = "prev_page_url"
        case path
        case from
        case toCategory = "to"
        case kinds = "data"
    }

    subscript(kindName: String) -> Category.Kind? {
        return kinds.first { kind -> Bool in
            return kind.name == kindName
        }
    }

    subscript(index: UInt64) -> Category.Kind? {
        return kinds.first { kind -> Bool in
                kind.id == index
        }
    }
}
