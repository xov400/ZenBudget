//
//  AlertAction.swift
//  ZenBudget
//
//  Created by Александр on 19.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

final class AlertAction {

    let title: String?
    var handler: (() -> Void)?

    init(title: String? = nil, handler: (() -> Void)? = nil) {
        self.title = title
        self.handler = handler
    }
}
