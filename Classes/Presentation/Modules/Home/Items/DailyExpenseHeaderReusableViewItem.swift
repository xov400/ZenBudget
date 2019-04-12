//
//  DailyExpenseHeaderItem.swift
//  ZenBudget
//
//  Created by Александр on 8.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import CollectionViewTools

final class DailyExpenseHeaderReusableViewItem: CollectionViewReusableViewItem {

    var type: ReusableViewType
    private var text: String

    init(type: ReusableViewType, text: String) {
        self.type = type
        self.text = text
    }

    func size(for collectionView: UICollectionView, with layout: UICollectionViewLayout) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 28)
    }

    func view(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: NSStringFromClass(DailyExpenseHeaderReusableView.self),
                                    for: indexPath) as? DailyExpenseHeaderReusableView {
            view.label.text = text
            view.setNeedsLayout()
            view.layoutIfNeeded()
            return view
        }
        return UICollectionReusableView()
    }

    func register(for collectionView: UICollectionView) {
        collectionView.register(DailyExpenseHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: NSStringFromClass(DailyExpenseHeaderReusableView.self))
    }
}
