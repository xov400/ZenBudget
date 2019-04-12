//
//  UpdatePasswordError.swift
//  ZenBudget
//
//  Created by Александр on 28.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class UpdatePasswordError: Error, Decodable {
    let reason: String
}
