//
//  AuthEndpointError.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class AuthEndpointError: Error, Decodable {
    let message: String
    let errors: FieldErrors
}

class FieldErrors: Decodable {
    let email: [String]?
    let password: [String]?
}
