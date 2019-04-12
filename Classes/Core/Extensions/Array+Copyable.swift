//
//  Array+.swift
//  ZenBudget
//
//  Created by Александр on 15.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

extension Array: Copyable where Element: Copyable {

    func copy() -> [Element] {
        return map { element -> Element in
            return element.copy()
        }
    }
}
