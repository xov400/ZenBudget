//
//  SignUpService.swift
//  ZenBudget
//
//  Created by Александр on 22.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

final class AuthService: AuthServiceProtocol {

    private var sessionService: SessionServiceProtocol
    private var errorHandlingService: ErrorHandlingServiceProtocol

    init(sessionService: SessionServiceProtocol, errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        self.errorHandlingService = errorHandlingService
    }

    func register(parameters: SignUpParameters, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = AuthEndpoint.registration(parameters: parameters)
        let request = DataRequest.request(endpoint: endpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                        self.sessionService.session = Session(user: authResponse.user, token: authResponse.token)
                        success()
                    } catch {
                        failure(error)
                    }
                }
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }

    func login(parameters: LoginParameters, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = AuthEndpoint.login(parameters: parameters)
        let request = DataRequest.request(endpoint: endpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        self.sessionService.session = Session(token: loginResponse.token)
                        success()
                    } catch {
                        failure(error)
                    }
                }
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }

    func resetPassword(parameters: ForgotPasswordParameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = AuthEndpoint.resetPassword(parameters: parameters)
        let request = DataRequest.request(endpoint: endpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                success("Ссылка для восстановления пароля отправлена на Ваш email")
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }

    func logout() {
        sessionService.session = nil
    }

    func updatePassword(parameters: UpdatePasswordParameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = AuthEndpoint.updatePassword(parameters: parameters)
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                success("Пароль успешно изменен")
            case .failure(var error):
                self.errorHandlingService.handle(error: &error, response: response, endpoint: endpoint)
                failure(error)
            }
        }
    }
}
