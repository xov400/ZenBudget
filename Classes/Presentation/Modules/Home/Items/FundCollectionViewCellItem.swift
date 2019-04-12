//
//  FundCollectionViewCellItem.swift
//  ZenBudget
//
//  Created by Александр on 2.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import CollectionViewTools

final class FundCollectionViewCellItem: CollectionViewCellItem {

    typealias Cell = FundCollectionViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)

    private var coloredFund: ColoredCategory

    init(coloredFund: ColoredCategory) {
        self.coloredFund = coloredFund
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.fundLabel.text = coloredFund.category.name
        cell.additionLabel.text = "\(coloredFund.category.amount) р."
        cell.backgroundColor = coloredFund.color
    }

    func size() -> CGSize {
        return CGSize(width: "\(coloredFund.category.name) \(coloredFund.category.amount) р.".width(withConstrainedHeight: 20),
                      height: 30)
    }
}
