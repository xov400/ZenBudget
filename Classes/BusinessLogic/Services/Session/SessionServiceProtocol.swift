//
//  SessionServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

protocol HasSessionService {
    var sessionService: SessionServiceProtocol { get }
}

protocol SessionServiceProtocol {
    var session: Session? { get set }
    var isAuthorized: Bool { get }
}
