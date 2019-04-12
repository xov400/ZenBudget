//
//  AddFundCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 9.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class AddCategoryCollectionViewCell: UICollectionViewCell {

    private enum Constants {
        static let insets = UIEdgeInsets(top: 16, left: 30, bottom: 16, right: 30)
    }

    private(set) lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(size: 15)
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.sea, for: .normal)
        button.setTitleColor(UIColor.sea.withAlphaComponent(0.5), for: .highlighted)
        button.setBackgroundImage(UIImage.colored(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .highlighted)
        button.clipsToBounds = true
        let layer = button.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.sea.cgColor
        layer.cornerRadius = 4
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        contentView.addSubview(addCategoryButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addCategoryButton.configureFrame { maker in
            maker.sizeToFit()
            maker.edges(insets: Constants.insets    )
        }
    }
}
