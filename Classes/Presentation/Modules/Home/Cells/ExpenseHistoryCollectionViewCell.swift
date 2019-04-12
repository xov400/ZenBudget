//
//  ExpenseCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 5.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class ExpenseHistoryCollectionViewCell: UICollectionViewCell {

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12, weight: .bold)
        label.textColor = UIColor.black
        label.text = "История расходов"
        return label
    }()

    private(set) lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 15)
        label.textColor = UIColor.black
        return label
    }()

    private(set) lazy var fundAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 20)
        label.textColor = UIColor.black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        contentView.addSubview(fundAmountLabel)
        contentView.addSubview(headerLabel)
        contentView.addSubview(monthLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        fundAmountLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.bottom(inset: 7).right(inset: 30)
        }
        headerLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.top(inset: 18).left(inset: 30)
        }
        monthLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.bottom(inset: 7).left(inset: 30)
        }
    }
}
