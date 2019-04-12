//
//  MonthFundsCollectionViewCellItem.swift
//  ZenBudget
//
//  Created by Александр on 2.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import CollectionViewTools

final class MonthFundsCollectionViewCellItem: CollectionViewCellItem {

    typealias Cell = MonthFundsCollectionViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)
    private static let sizeCell: Cell = .init()

    private var coloredFunds: [ColoredCategory]

    init(coloredFunds: [ColoredCategory]) {
        self.coloredFunds = coloredFunds
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.coloredFunds = coloredFunds
    }

    func size() -> CGSize {
        if let collectionView = collectionView {
            let sizeCell = type(of: self).sizeCell
            configure(sizeCell)
            let insets = sectionItem?.insets ?? .zero
            return sizeCell.sizeThatFits(CGSize(width: collectionView.bounds.width - insets.left - insets.right, height: .greatestFiniteMagnitude))
        }
        return CGSize.zero
    }
}
