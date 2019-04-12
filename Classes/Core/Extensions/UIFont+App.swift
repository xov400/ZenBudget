//
//  UIFont+ProximaNova.swift
//  ZenBudget
//
//  Created by Александр on 20.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

extension UIFont {

    static func appFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Proxima Nova", size: size)!
    }

    static func appFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .bold:
            return UIFont(name: "ProximaNova-Bold", size: size)!
        default:
            return UIFont(name: "Proxima Nova", size: size)!
        }
    }
}
