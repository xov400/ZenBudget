//
//  DailyExpensesCollectionViewCellItem.swift
//  ZenBudget
//
//  Created by Александр on 2.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import CollectionViewTools

final class DailyExpensesCollectionViewCellItem: CollectionViewCellItem {

    typealias Cell = DailyExpensesCollectionViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)

    private var residue: Double
    private var percent: Double

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()

    init(residue: Double, percent: Double) {
        self.residue = residue
        self.percent = percent
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }

        let formattedCost = numberFormatter.string(from: NSNumber(value: residue))!
        let costAttributedString = NSMutableAttributedString(string: formattedCost, attributes: StringAttributes.costAttributes)
        let currencyAttributedString = NSAttributedString(string: " р.", attributes: StringAttributes.currencyAttributes)
        costAttributedString.append(currencyAttributedString)

        cell.residueLabel.attributedText = costAttributedString
        cell.scaleView.percentage = min(1, CGFloat(percent))
    }

    func size() -> CGSize {
        if let collectionView = collectionView {
            return CGSize(width: collectionView.bounds.width * 0.95, height: 215)
        }
        return CGSize(width: 0, height: 0)
    }
}
