//
//  ProfileService.swift
//  ZenBudget
//
//  Created by Александр on 1.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import Alamofire

final class ProfileService: ProfileServiceProtocol {

    private var sessionService: SessionServiceProtocol
    private var errorHandlingService: ErrorHandlingServiceProtocol

    init(sessionService: SessionServiceProtocol, errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        self.errorHandlingService = errorHandlingService
    }

    func sendMeRequest(success: @escaping (User) -> Void, failure: @escaping (Error) -> Void) {
        let endpoint = ProfileEndpoint.fetchProfile
        let authorizedEndpoint = AuthorizedEndpoint.endpoint(source: endpoint, token: sessionService.session?.token)
        let request = DataRequest.request(endpoint: authorizedEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        self.sessionService.session?.user = user
                        success(user)
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
}
