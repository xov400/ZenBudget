//
//  String+Size.swift
//  ZenBudget
//
//  Created by Александр on 14.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

extension String {

    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: StringAttributes.fundsAttributes, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: StringAttributes.fundsAttributes, context: nil)

        return ceil(boundingBox.width) + 10
    }
}
