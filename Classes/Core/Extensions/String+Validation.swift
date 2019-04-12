//
//  String+Validation.swift
//  ZenBudget
//
//  Created by Александр on 21.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

extension String {

    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }

    var isValidPassword: Bool {
        let passwordRegex = "((?=.*\\d)(?=.*[A-Za-z]).{6,})"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }

    var isValidAmount: Bool {
        let emailRegex = "[0-9]{0,}.[0-9]{0,2}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
}
