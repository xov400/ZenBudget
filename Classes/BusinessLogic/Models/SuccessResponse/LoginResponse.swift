//
//  LoginResponse.swift
//  ZenBudget
//
//  Created by Александр on 28.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class LoginResponse: Decodable {

    let token: String
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case token
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
