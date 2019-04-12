//
//  SignUpEndpoint.swift
//  ZenBudget
//
//  Created by Александр on 26.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

enum AuthEndpoint {
    case registration(parameters: SignUpParameters)
    case login(parameters: LoginParameters)
    case resetPassword(parameters: ForgotPasswordParameters)
    case updatePassword(parameters: UpdatePasswordParameters)
}

extension AuthEndpoint: Endpoint {

    var requiresAuthorization: Bool {
        return false
    }

    var path: String {
        switch self {
        case .registration:
            return "user/"
        case .login:
            return "auth/login"
        case .resetPassword:
            return "auth/forgot-password"
        case .updatePassword:
            return "user/update-password"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .registration:
            return .post
        case .login:
            return .post
        case .resetPassword:
            return .post
        case .updatePassword:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .registration(let parameters):
            return ["email": parameters.email,
                    "password": parameters.password,
                    "password_confirmation": parameters.passwordConfirmation]
        case .login(let parameters):
            return ["email": parameters.email,
                    "password": parameters.password]
        case .resetPassword(let parameters):
            return ["email": parameters.email]
        case .updatePassword(let parameters):
            return ["password": parameters.oldPassword,
                    "new_password": parameters.newPassword,
                    "new_password_confirmation": parameters.passwordConfirmation]
        }
    }

    var httpHeaders: HTTPHeaders {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}

extension AuthEndpoint: EndpointError {

    func error(forStatusCode statusCode: Int, responseData: Data) -> Error? {
        if let error: AuthEndpointError = try? AuthEndpointError.error(from: responseData) {
            return error
        }
        if let error: UpdatePasswordError = try? UpdatePasswordError.error(from: responseData) {
            return error
        }
        switch statusCode {
        default:
            return nil
        }
    }
}
