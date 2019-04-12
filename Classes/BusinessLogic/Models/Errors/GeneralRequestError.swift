//
//  GeneralRequestError.swift
//  ZenBudget
//
//  Created by Александр on 27.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

enum GeneralRequestError: Error {
    case notConnectedToInternet
    case timedOut
    case unauthorized
}

extension GeneralRequestError: LocalizedError {

    var localizedDescription: String {
        switch self {
        case .notConnectedToInternet:
            return "Нет соединения с интернетом"
        case .timedOut:
            return "Очень медленное интернет-соединение"
        case .unauthorized:
            return "Неправильная пара логин-пароль"
        }
    }
}
