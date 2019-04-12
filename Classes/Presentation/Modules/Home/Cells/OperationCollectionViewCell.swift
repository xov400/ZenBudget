//
//  ExpenceItemCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 5.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class OperationCollectionViewCell: UICollectionViewCell {

    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 15)
        label.textColor = UIColor.black
        return label
    }()

    private(set) lazy var fundLabel: InsetLabel = {
        let label = InsetLabel()
        label.insets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()

    private(set) lazy var costLabel: UILabel = .init()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteSmoke
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        contentView.addSubview(nameLabel)
        contentView.addSubview(fundLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(separatorView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.top(inset: 16).left(inset: 28)
        }
        fundLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.top(to: nameLabel.nui_bottom, inset: 4).left(inset: 28)
        }
        costLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.top(to: nameLabel.nui_top).right(inset: 28)
        }
        separatorView.configureFrame { maker in
            maker.size(width: bounds.width, height: 1)
            maker.bottom()
        }
    }
}
