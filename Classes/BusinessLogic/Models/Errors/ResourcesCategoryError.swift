//
//  ResourcesCategoryError.swift
//  ZenBudget
//
//  Created by Александр on 20.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class ResourcesCategoryError: Error, Decodable {
    let error: String
}
