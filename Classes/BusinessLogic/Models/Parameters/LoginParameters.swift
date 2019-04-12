//
//  LoginParameters.swift
//  ZenBudget
//
//  Created by Александр on 28.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class LoginParameters {
    let email: String
    let password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
