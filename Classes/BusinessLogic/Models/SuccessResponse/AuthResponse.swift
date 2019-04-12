//
//  AuthResponse.swift
//  ZenBudget
//
//  Created by Александр on 22.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class AuthResponse: Decodable {

    let user: User
    let token: String
}
