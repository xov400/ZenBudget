//
//  ColoredOperation.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class ColoredOperation {

    let operation: Operation
    let color: UIColor

    init(operation: Operation, color: UIColor) {
        self.operation = operation
        self.color = color
    }
}
