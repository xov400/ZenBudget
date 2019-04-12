//
//  TextField.swift
//  ZenBudget
//
//  Created by Александр on 20.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class TextField: UITextField {

    var lineColor: UIColor = UIColor.white.withAlphaComponent(0.4) {
        didSet {
            lineView.backgroundColor = lineColor
        }
    }

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = lineColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.configureFrame { maker in
            maker.size(width: bounds.width, height: 1)
            maker.bottom()
            maker.centerX()
        }
    }
}
