//
//  DailyExpensesCollectionViewCell.swift
//  ZenBudget
//
//  Created by Александр on 24.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class DailyExpensesCollectionViewCell: UICollectionViewCell {

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12, weight: .bold)
        label.textColor = UIColor.black
        label.text = "Ежедневные расходы"
        return label
    }()

    private(set) lazy var scaleView = ScaleDrawView()

    private lazy var savingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "Экономия"
        return label
    }()

    private lazy var normLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "Норма"
        return label
    }()

    private lazy var overrunLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "Перерасход"
        return label
    }()

    private lazy var stayForTodayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "Осталось на сегодня"
        return label
    }()

    private(set) lazy var residueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 20)
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = UIColor.white
        layer.cornerRadius = 6
        contentView.addSubview(headerLabel)
        contentView.addSubview(scaleView)
        contentView.addSubview(savingLabel)
        contentView.addSubview(normLabel)
        contentView.addSubview(overrunLabel)
        contentView.addSubview(stayForTodayLabel)
        contentView.addSubview(residueLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let height = bounds.height
        let width = bounds.width
        headerLabel.configureFrame { maker in
            maker.height(16).widthToFit()
            maker.top(inset: height * 0.07).left(inset: width * 0.05)
        }
        normLabel.configureFrame { maker in
            maker.sizeToFit().centerX().top(inset: height * 0.2)
        }
        scaleView.configureFrame { maker in
            maker.size(width: round(width * 0.52), height: round(height * 0.4))
            maker.centerX().top(to: normLabel.nui_bottom)
        }
        savingLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.top(inset: height * 0.61).right(to: scaleView.nui_left)
        }
        overrunLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.top(inset: height * 0.61).left(to: scaleView.nui_right)
        }
        stayForTodayLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.centerX().top(to: scaleView.nui_bottom, inset: 10)
        }
        residueLabel.configureFrame { maker in
            maker.sizeToFit()
            maker.centerX().top(to: stayForTodayLabel.nui_bottom, inset: 5)
        }
    }
}
