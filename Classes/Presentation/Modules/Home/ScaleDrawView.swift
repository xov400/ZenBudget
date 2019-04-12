//
//  ScaleDrawView.swift
//  ZenBudget
//
//  Created by Александр on 25.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import CoreGraphics

final class ScaleDrawView: UIView {

    var percentage: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    private lazy var scale: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 35.0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        return layer
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.toxicGreen.cgColor, UIColor.sea.cgColor, UIColor.melon.cgColor]
        layer.locations = [0.0, 0.5, 1.0]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()

    private lazy var cursor: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.addSublayer(gradientLayer)
        layer.addSublayer(cursor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        scale.frame = CGRect(x: 0, y: 5, width: bounds.width, height: bounds.height - 5)
        cursor.frame = bounds
    }

    override func draw(_ rect: CGRect) {
        let width = bounds.width
        let height = bounds.height
        let scaleRadius = height - 17.5
        let center = CGPoint(x: width / 2, y: height)
        let scalePath = UIBezierPath(arcCenter: center, radius: scaleRadius, startAngle: .pi, endAngle: 0, clockwise: true)
        scale.path = scalePath.cgPath
        gradientLayer.mask = scale

        let cursorPath = UIBezierPath()
        cursorPath.move(to: CGPoint(x: width / 2, y: height))
        let cursorRadius = scaleRadius + 17
        let endPoint = CGPoint(x: cursorRadius * cos(CGFloat.radians(fromPercent: percentage)) + width / 2,
                               y: -(cursorRadius * sin(CGFloat.radians(fromPercent: percentage))) + height)
        cursorPath.addLine(to: endPoint)
        cursor.path = cursorPath.cgPath
    }
}
