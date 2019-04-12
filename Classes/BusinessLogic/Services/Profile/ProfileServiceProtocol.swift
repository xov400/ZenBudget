//
//  ProfileServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 1.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

protocol HasProfileService {
    var profileService: ProfileServiceProtocol { get }
}

protocol ProfileServiceProtocol {
    func sendMeRequest(success: @escaping (User) -> Void, failure: @escaping (Error) -> Void)
}
