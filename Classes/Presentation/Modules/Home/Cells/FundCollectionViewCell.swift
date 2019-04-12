//
//  FundCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 2.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class FundCollectionViewCell: UICollectionViewCell {

    private enum Constants {
        static let insets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        static let additionLabelRightInset: CGFloat = 0
    }

    private(set) lazy var fundLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.white
        return label
    }()

    private(set) lazy var additionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12, weight: .bold)
        label.textColor = UIColor.white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 3
        contentView.addSubview(fundLabel)
        contentView.addSubview(additionLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        fundLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.centerY().left(inset: Constants.insets.left)
        }
        additionLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.centerY().right(inset: Constants.insets.right)
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var width = Constants.insets.left
        width += fundLabel.sizeThatFits(size.insetsSize(insets: Constants.insets)).width
        width += Constants.additionLabelRightInset
        width += additionLabel.sizeThatFits(size.insetsSize(insets: Constants.insets)).width
        width += Constants.insets.right
        let size = CGSize(width: width, height: size.height)
        return size
    }
}
