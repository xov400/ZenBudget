//
//  Pagination.swift
//  ZenBudget
//
//  Created by Александр on 15.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class Pagination: Decodable {
    var pageNumber: Int
    let elementsPerPage: Int
    var isLastPage: Bool

    init(pageNumber: Int, elementsPerPage: Int, isLastPage: Bool) {
        self.pageNumber = pageNumber
        self.elementsPerPage = elementsPerPage
        self.isLastPage = isLastPage
    }
}
