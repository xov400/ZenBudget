//
//  ExpenseHistoryCollectionViewCellItem.swift
//  ZenBudget
//
//  Created by Александр on 6.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import CollectionViewTools

final class ExpenseHistoryCollectionViewCellItem: CollectionViewCellItem {

    typealias Cell = ExpenseHistoryCollectionViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)

    private var month: String
    private var fundAmount: Double

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()

    init(month: String, fundAmount: Double) {
        self.month = month
        self.fundAmount = fundAmount
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.monthLabel.text = "Расходы за \(month)"

        let formattedCost = numberFormatter.string(from: NSNumber(value: fundAmount))!
        let costAttributedString = NSMutableAttributedString(string: formattedCost, attributes: StringAttributes.costAttributes)
        let currencyAttributedString = NSAttributedString(string: " р.", attributes: StringAttributes.currencyAttributesWithAlpha)
        costAttributedString.append(currencyAttributedString)

        cell.fundAmountLabel.attributedText = costAttributedString

        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }

    func size() -> CGSize {
        if let collectionView = collectionView {
            return CGSize(width: collectionView.bounds.width, height: 65)
        }
        return CGSize.zero
    }
}
