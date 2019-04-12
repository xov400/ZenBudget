//
//  UpdatePasswordParameters.swift
//  ZenBudget
//
//  Created by Александр on 28.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class UpdatePasswordParameters {
    let oldPassword: String
    let newPassword: String
    let passwordConfirmation: String

    init(oldPassword: String, newPassword: String, passwordConfirmation: String) {
        self.oldPassword = oldPassword
        self.newPassword = newPassword
        self.passwordConfirmation = passwordConfirmation
    }
}
