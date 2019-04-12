//
//  SessionService.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class SessionService: SessionServiceProtocol {

    private static var shared: SessionService?
    private var keychainService: KeychainServiceProtocol

    private init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
        if let token = keychainService["token"] {
            session = Session(token: token)
        }
    }

    static func shared(keychainService: KeychainServiceProtocol) -> SessionService {
        if shared == nil {
            shared = SessionService(keychainService: keychainService)
        }
        return shared!
    }

    var session: Session? {
        didSet {
            if let session = session {
                keychainService["token"] = session.token
            } else {
                keychainService["token"] = nil
            }
        }
    }

    var isAuthorized: Bool {
        return session != nil
    }
}
