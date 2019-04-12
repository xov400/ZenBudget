//
//  CGSize+Insets.swift
//  ZenBudget
//
//  Created by Александр on 11.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

extension CGSize {
    func insetsSize(insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - insets.left - insets.right,
                      height: height - insets.top - insets.bottom)
    }

    func offsetSize(insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width + insets.left + insets.right,
                      height: height + insets.top + insets.bottom)
    }
}
