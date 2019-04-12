//
//  CharacterSet+App.swift
//  ZenBudget
//
//  Created by Александр on 16.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

extension CharacterSet {
    public static var legalAmountSymbols: CharacterSet {
        var legalAmountSymbols = CharacterSet.decimalDigits
        legalAmountSymbols.insert(charactersIn: ".")
        return legalAmountSymbols
    }
}
