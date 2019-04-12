//
//  SignUpParameters.swift
//  ZenBudget
//
//  Created by Александр on 28.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class SignUpParameters {
    let email: String
    let password: String
    let passwordConfirmation: String

    init(email: String, password: String, passwordConfirmation: String) {
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
