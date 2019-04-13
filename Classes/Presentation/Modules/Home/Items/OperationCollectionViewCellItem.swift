//
//  ExpenceItemCollectionViewCellItem.swift
//  ZenBudget
//
//  Created by Александр on 6.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import CollectionViewTools

final class OperationCollectionViewCellItem: CollectionViewCellItem {

    typealias Cell = OperationCollectionViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)

    private let operation: Operation
    private let color: UIColor

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()

    init(operation: Operation, color: UIColor) {
        self.operation = operation
        self.color = color
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.nameLabel.text = operation.operationName

        let firstCategory = Services.categoriesService.coloredCategories.first { category -> Bool in
            return category.category.id == operation.categoryID
        }

        if let category = firstCategory {
            cell.fundLabel.text = category.category.name
        } else {
            cell.fundLabel.text = "Удалена"
        }
        cell.fundLabel.backgroundColor = color

        let formattedCost = numberFormatter.string(from: NSNumber(value: operation.amount))!
        let costAttributedString = NSMutableAttributedString(string: formattedCost, attributes: StringAttributes.costAttributes)
        let currencyAttributedString = NSAttributedString(string: " р.", attributes: StringAttributes.currencyAttributesWithAlpha)
        costAttributedString.append(currencyAttributedString)

        cell.costLabel.attributedText = costAttributedString

        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }

    func size() -> CGSize {
        if let collectionView = collectionView {
            return CGSize(width: collectionView.bounds.width, height: 75)
        }
        return CGSize.zero
    }
}
