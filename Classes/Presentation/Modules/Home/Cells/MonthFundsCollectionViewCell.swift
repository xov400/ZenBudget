//
//  MonthFundsCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 5.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla
import CollectionViewTools

final class MonthFundsCollectionViewCell: UICollectionViewCell {

    private enum Constants {
        static let insets = UIEdgeInsets(top: 16, left: 20, bottom: 19, right: 20)
        static let collectionViewTopInset: CGFloat = 15
        static let lineSpacing: CGFloat = 10
        static let interitemSpacing: CGFloat = 10
    }

    var coloredFunds: [ColoredCategory] = [] {
        didSet {
            collectionViewManager.sectionItems = sectionItems
        }
    }

    private var cellItems: [FundCollectionViewCellItem] {
        return coloredFunds.map { coloredFund in
            return FundCollectionViewCellItem(coloredFund: coloredFund)
        }
    }

    private var sectionItems: [CollectionViewSectionItem] {
        let monthFundSectionItem = GeneralCollectionViewSectionItem(cellItems: cellItems)
        monthFundSectionItem.minimumLineSpacing = Constants.lineSpacing
        return [monthFundSectionItem]
    }

    private(set) lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12, weight: .bold)
        label.textColor = UIColor.black
        label.text = "Фонды на этот месяц"
        return label
    }()

    private lazy var collectionViewLayout: AlignedCollectionViewFlowLayout = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.scrollDirection = .vertical
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private lazy var collectionViewManager = CollectionViewManager(collectionView: collectionView)

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = UIColor.white
        layer.cornerRadius = 6
        contentView.addSubview(headerLabel)
        contentView.addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let sizeInsets = bounds.size.insetsSize(insets: Constants.insets)
        headerLabel.configureFrame { maker in
            maker.sizeThatFits(size: sizeInsets)
            maker.top(inset: Constants.insets.top).left(inset: Constants.insets.left)
        }
        collectionView.configureFrame { maker in
            maker.top(to: headerLabel.nui_bottom, inset: Constants.collectionViewTopInset)
            maker.edges(left: Constants.insets.left, bottom: Constants.insets.bottom, right: Constants.insets.right)
        }
    }

    private func collectionViewSizeThatFits(_ size: CGSize) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        cellItems.forEach { cellItem in
            let cellItemSize = cellItem.size()
            var estimatedWidth: CGFloat = width
            if estimatedWidth != 0 {
                estimatedWidth += Constants.interitemSpacing
            }
            estimatedWidth += cellItemSize.width
            if height == 0 {
                height = cellItemSize.height
            }
            if estimatedWidth <= size.width {
                width = estimatedWidth
            } else {
                height += Constants.lineSpacing + cellItemSize.height
                width = cellItemSize.width
            }
        }
        return CGSize(width: width, height: height)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height = Constants.insets.top
        height += headerLabel.sizeThatFits(size.insetsSize(insets: Constants.insets)).height
        height += Constants.collectionViewTopInset
        height += collectionViewSizeThatFits(size.insetsSize(insets: Constants.insets)).height
        height += Constants.insets.bottom
        return CGSize(width: size.width, height: height)
    }
}
