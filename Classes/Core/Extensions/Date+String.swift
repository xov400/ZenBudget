//
//  Date+String.swift
//  ZenBudget
//
//  Created by Александр on 13.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {

    func toRelativeString() -> String {
        let rule = RelativeFormatter.Gradation.Rule(.day, threshold: nil)
        let gradation = RelativeFormatter.Gradation([rule])
        let relativeDateStyle = RelativeFormatter.Style(flavours: [.long], gradation: gradation)
        return toString(.relative(style: relativeDateStyle))
    }
}
