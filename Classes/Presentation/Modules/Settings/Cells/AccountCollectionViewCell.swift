//
//  AccountCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 9.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class AccountCollectionViewCell: UICollectionViewCell {

    private enum Constants {
        static let insets = UIEdgeInsets(top: 16, left: 30, bottom: 16, right: 30)
        static let buttonInset: CGFloat = 12
        static let buttonHeight = 45
    }

    private(set) lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 15, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()

    private(set) lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(size: 15)
        button.setTitle("Сменить пароль", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.sea, for: .normal)
        button.setTitleColor(UIColor.sea.withAlphaComponent(0.5), for: .highlighted)
        button.setBackgroundImage(UIImage.colored(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .highlighted)
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.sea.cgColor
        button.layer.cornerRadius = 4
        return button
    }()

    private(set) lazy var exitAccountButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.appFont(size: 17)
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.sea, for: .normal)
        button.setTitleColor(UIColor.sea.withAlphaComponent(0.5), for: .highlighted)
        button.setBackgroundImage(UIImage.colored(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .highlighted)
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.sea.cgColor
        button.layer.cornerRadius = 4
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        contentView.addSubview(headerLabel)
        contentView.addSubview(changePasswordButton)
        contentView.addSubview(exitAccountButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.configureFrame { maker in
            maker.size(width: bounds.width, height: 20)
            maker.top(inset: Constants.insets.top).centerX()
        }
        changePasswordButton.configureFrame { maker in
            maker.widthToFit().height(Constants.buttonHeight)
            maker.top(to: headerLabel.nui_bottom, inset: Constants.buttonInset)
            maker.left(inset: Constants.insets.left).right(inset: Constants.insets.right)
        }
        exitAccountButton.configureFrame { maker in
            maker.widthToFit().height(Constants.buttonHeight)
            maker.top(to: changePasswordButton.nui_bottom, inset: Constants.buttonInset)
            maker.left(inset: Constants.insets.left).right(inset: Constants.insets.right)
        }
    }
}
