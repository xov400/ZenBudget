//
//  ColorServiceProtocol.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

protocol HasColorService {
    var colorService: ColorServiceProtocol { get }
}

protocol ColorServiceProtocol {
    func coloring() -> UIColor
}
