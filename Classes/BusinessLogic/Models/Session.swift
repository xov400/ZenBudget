//
//  Session.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class Session {

    var user: User?
    let token: String

    init(user: User? = nil, token: String) {
        self.user = user
        self.token = token
    }
}
