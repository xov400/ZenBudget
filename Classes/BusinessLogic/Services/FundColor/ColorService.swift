//
//  ColorService.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class ColorService: ColorServiceProtocol {

    private let colors = [UIColor.red,
                          UIColor.green,
                          UIColor.gray,
                          UIColor.blue,
                          UIColor.orange,
                          UIColor.purple,
                          UIColor.magenta,
                          UIColor.yellow,
                          UIColor.cyan]
    private var increment = -1

    func coloring() -> UIColor {
        if increment < colors.count - 1 {
            increment += 1
        } else {
            increment = 0
        }
        return colors[increment]
    }
}
