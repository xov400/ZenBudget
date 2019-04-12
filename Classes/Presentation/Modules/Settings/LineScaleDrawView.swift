//
//  LineScaleDrawView.swift
//  ZenBudget
//
//  Created by Александр on 10.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import CoreGraphics

final class LineScaleDrawView: UIView {

    private lazy var scale: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.sea.withAlphaComponent(0.4).cgColor
        return layer
    }()

    private lazy var scaleFiller: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.sea.cgColor
        return layer
    }()

    var percentage: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.addSublayer(scale)
        layer.addSublayer(scaleFiller)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scale.frame = bounds
        scaleFiller.frame = bounds
    }

    override func draw(_ rect: CGRect) {
        let scalePath = UIBezierPath()
        scalePath.move(to: CGPoint(x: 0, y: 1))
        scalePath.addLine(to: CGPoint(x: bounds.width, y: 1))
        scale.path = scalePath.cgPath

        let scaleFillerPath = UIBezierPath()
        scaleFillerPath.move(to: CGPoint(x: 0, y: 1))
        scaleFillerPath.addLine(to: CGPoint(x: scale.bounds.width * percentage, y: 1))
        scaleFiller.path = scaleFillerPath.cgPath
    }
}
