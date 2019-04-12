//
//  LoaderCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 13.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class LoaderCollectionViewCell: UICollectionViewCell {

    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(activityIndicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.configureFrame { maker in
            maker.center()
        }
    }
}
