//
//  DailyExpenseHeader.swift
//  ZenBudget
//
//  Created by Александр on 8.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class DailyExpenseHeaderReusableView: UICollectionReusableView {

    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.dustyGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        backgroundColor = UIColor.whiteSmoke
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.zPosition = 0
        label.configureFrame { maker in
            maker.sizeToFit().bottom(inset: bounds.height * 0.11).left(inset: bounds.width * 0.07)
        }
    }
}
