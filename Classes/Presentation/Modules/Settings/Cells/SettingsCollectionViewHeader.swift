//
//  CollectionViewHeader.swift
//  ZenBudget
//
//  Created by Александр on 11.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class SettingsCollectionViewHeader: UICollectionReusableView {

    private enum Constants {
        static let leftInset: CGFloat = 26
        static let bottomInset: CGFloat = 4
    }

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.dustyGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.configureFrame { maker in
            maker.size(width: bounds.width - Constants.leftInset, height: 16)
            maker.bottom(inset: Constants.bottomInset).left(inset: Constants.leftInset)
        }
    }
}
