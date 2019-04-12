//
//  FundCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 9.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {

    private enum Constants {
        static let insets = UIEdgeInsets(top: 12, left: 30, bottom: 12, right: 30)
        static let descriptionLabelTopInset: CGFloat = 6
        static let lineScaleViewTopInset: CGFloat = 6
    }

    private(set) lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 15)
        label.textColor = UIColor.black
        return label
    }()

    private(set) lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 20)
        label.textColor = UIColor.black
        return label
    }()

    private(set) lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        return label
    }()

    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        return label
    }()

    private(set) lazy var lineScaleView = LineScaleDrawView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(lineScaleView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let insetSize = contentView.bounds.size.insetsSize(insets: Constants.insets)

        amountLabel.configureFrame { maker in
            maker.sizeThatFits(size: insetSize)
            maker.top(inset: Constants.insets.top).right(inset: Constants.insets.right)
        }
        categoryNameLabel.configureFrame { maker in
            maker.top(inset: Constants.insets.top).left(inset: Constants.insets.left)
            maker.right(to: amountLabel.nui_left, inset: 16).heightToFit()
        }
        descriptionLabel.configureFrame { maker in
            maker.sizeThatFits(size: insetSize)
            maker.top(to: categoryNameLabel.nui_bottom, inset: Constants.descriptionLabelTopInset).right(inset: Constants.insets.right)
        }
        typeLabel.configureFrame { maker in
            maker.top(to: descriptionLabel.nui_top).left(inset: Constants.insets.left)
            maker.right(to: descriptionLabel.nui_left, inset: 16).heightToFit()
        }
        lineScaleView.configureFrame { maker in
            maker.size(width: bounds.width - Constants.insets.left - Constants.insets.right, height: 2)
            maker.centerX().top(to: descriptionLabel.nui_bottom, inset: Constants.lineScaleViewTopInset)
        }
    }
}
