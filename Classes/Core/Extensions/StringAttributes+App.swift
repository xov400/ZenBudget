//
//  StringAttributes+App.swift
//  ZenBudget
//
//  Created by Александр on 21.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

typealias StringAttributes = [NSAttributedString.Key: Any]

extension Dictionary where Key == NSAttributedString.Key, Value: Any {

    static var textFieldAuthPlaceholderAttributes: StringAttributes {
        return [
            .foregroundColor: UIColor.white.withAlphaComponent(0.4),
            .font: UIFont.appFont(size: 20)
        ]
    }

    static var headerTextAttributes: StringAttributes {
        return [
            .foregroundColor: UIColor.white,
            .font: UIFont.appFont(size: 15, weight: .bold)
        ]
    }

    static var fundsAttributes: StringAttributes {
        return [
            .foregroundColor: UIColor.white,
            .font: UIFont.appFont(size: 12, weight: .bold)
        ]
    }

    static var backButtonTextAttributes: StringAttributes {
        return [
            .foregroundColor: UIColor.clear
        ]
    }

    static var costAttributes: StringAttributes {
        return [
            .font: UIFont.appFont(size: 20),
            .foregroundColor: UIColor.black
        ]
    }

    static var currencyAttributes: StringAttributes {
        return [
            .font: UIFont.appFont(size: 12),
            .foregroundColor: UIColor.black
        ]
    }

    static var currencyAttributesWithAlpha: StringAttributes {
        return [
            .font: UIFont.appFont(size: 12),
            .foregroundColor: UIColor.black.withAlphaComponent(0.4)
        ]
    }

    static var textFieldRecordPlaceholderAttributes: StringAttributes {
        return [
            .foregroundColor: UIColor.black.withAlphaComponent(0.4),
            .font: UIFont.appFont(size: 20)
        ]
    }
}
