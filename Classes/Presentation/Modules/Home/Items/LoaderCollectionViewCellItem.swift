//
//  LoaderCollectionViewCellItem.swift
//  ZenBudget
//
//  Created by Александр on 13.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation
import CollectionViewTools

final class LoaderCollectionViewCellItem: CollectionViewCellItem {

    typealias Cell = LoaderCollectionViewCell
    private(set) var reuseType: ReuseType = .class(Cell.self)

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.activityIndicator.startAnimating()
    }

    func size() -> CGSize {
        if let collectionView = collectionView {
            return CGSize(width: collectionView.bounds.width, height: 75)
        }
        return CGSize.zero
    }
}
