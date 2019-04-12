//
//  OperationsDataResponse.swift
//  ZenBudget
//
//  Created by Александр on 22.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class OperationsDataResponse: Decodable {

    let currentPage: Int
    let perPage: Int // Operations on the page
    let fromOperation: Int?
    let toOperation: Int?
    let totalOperations: Int
    let lastPage: Int

    let path: String
    let operations: [Operation]

    let firstPageURL: URL
    let lastPageURL: URL
    let nextPageURL: URL?
    let prevPageURL: URL?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case perPage = "per_page"
        case fromOperation = "from"
        case toOperation = "to"
        case totalOperations = "total"
        case lastPage = "last_page"
        case path = "path"
        case operations = "data"
        case firstPageURL = "first_page_url"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case prevPageURL = "prev_page_url"
    }
}
