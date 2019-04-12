//
//  ColoredOperation.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class ColoredCategory {

    let category: Category
    let color: UIColor

    init(category: Category, color: UIColor) {
        self.category = category
        self.color = color
    }
}
