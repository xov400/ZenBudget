//
//  SignUpServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 22.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

protocol HasAuthService {
    var authService: AuthServiceProtocol { get }
}

protocol AuthServiceProtocol {
    func register(parameters: SignUpParameters, success: @escaping () -> Void, failure: @escaping (Error) -> Void)
    func login(parameters: LoginParameters, success: @escaping () -> Void, failure: @escaping (Error) -> Void)
    func resetPassword(parameters: ForgotPasswordParameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void)
    func logout()
    func updatePassword(parameters: UpdatePasswordParameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void)
}
