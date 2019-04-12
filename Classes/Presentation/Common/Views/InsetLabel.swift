//
//  InsetLabel.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

extension CGRect {

    func offset(by insets: UIEdgeInsets) -> CGRect {
        return CGRect(x: origin.x - insets.left,
                      y: origin.y - insets.top,
                      width: width + insets.left + insets.right,
                      height: height + insets.top + insets.bottom)
    }
}

final class InsetLabel: UILabel {

    var insets: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.offset(by: insets))
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return super.sizeThatFits(size).offsetSize(insets: insets)
    }
}
