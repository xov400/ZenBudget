//
//  KindServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 19.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

protocol HasKindsService {
    var kindsService: KindsServiceProtocol { get }
}

protocol KindsServiceProtocol {
    var kindsDataResponse: KindsDataResponse? { get set }
    func fetchKindsService(success: @escaping (KindsDataResponse) -> Void, failure: @escaping (Error) -> Void)
}
