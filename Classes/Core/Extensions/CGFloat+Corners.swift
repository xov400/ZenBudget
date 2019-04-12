//
//  CGFloat+Corners.swift
//  ZenBudget
//
//  Created by Александр on 11.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

extension CGFloat {

    static func radians(fromPercent percent: CGFloat) -> CGFloat {
        let cornerInDegrees: CGFloat = 180.0 - percent * 180
        return cornerInDegrees * .pi / 180
    }
}
