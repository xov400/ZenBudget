//
//  ActionSheetAlertController.swift
//  ZenBudget
//
//  Created by Александр on 15.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class ActionSheetViewController: UIViewController {

    private enum Constants {
        static let containerInsets: UIEdgeInsets = .init(top: 20, left: 30, bottom: 20, right: 30)
        static let innerInsets: UIEdgeInsets = .init(top: 16, left: 0, bottom: 16, right: 0)
        static let buttonHeight: CGFloat = 50
        static let interitemSpacing: CGFloat = 8
    }

    // MARK: - Properties

    private var actions: [AlertAction] = []

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()

    private lazy var actionButtons: [UIButton] = {
        return actions.enumerated().map { index, alertAction -> UIButton in
            let button = UIButton()
            button.setTitle(alertAction.title, for: .normal)
            button.titleLabel?.font = UIFont.appFont(size: 15)
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(UIColor.sea, for: .normal)
            button.setBackgroundImage(UIImage.colored(UIColor.white), for: .normal)
            button.setBackgroundImage(UIImage.colored(UIColor.sea.withAlphaComponent(0.1)), for: .highlighted)
            button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
            button.clipsToBounds = true
            button.tag = index
            return button
        }
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
        tapRecognizer.cancelsTouchesInView = false
        return tapRecognizer
    }()

    private var bottomInset: CGFloat = 0

    // MARK: - Lifecycle

    init(actions: [AlertAction]) {
        self.actions = actions
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    override private init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addGestureRecognizer(tapRecognizer)

        view.addSubview(containerView)
        containerView.addSubviews(actionButtons)

        setInitialBottomInset()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        containerView.configureFrame { maker in
            maker.edges(left: Constants.containerInsets.left,
                        bottom: bottomInset,
                        right: Constants.containerInsets.right)
        }

        var height: CGFloat = Constants.innerInsets.top
        actionButtons.enumerated().forEach { index, button in
            button.configureFrame { maker in
                maker.top(inset: height).left().right().height(Constants.buttonHeight)
            }
            height += Constants.buttonHeight
            if index == actionButtons.indices.last {
                height += Constants.containerInsets.bottom
            } else {
                height += Constants.interitemSpacing
            }
        }

        containerView.configureFrame { maker in
            maker.height(height)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        bottomInset = Constants.containerInsets.bottom
        layoutAnimated()
    }

    // MARK: - Layout

    private func containerSizeThatFits(_ size: CGSize) -> CGSize {
        var height: CGFloat = Constants.innerInsets.top
        actionButtons.enumerated().forEach { index, _ in
            height += Constants.buttonHeight
            if index == actionButtons.indices.last {
                height += Constants.containerInsets.bottom
            } else {
                height += Constants.interitemSpacing
            }
        }
        return CGSize(width: size.width, height: height)
    }

    private func setInitialBottomInset() {
        let insetSize = view.bounds.inset(by: Constants.containerInsets).size
        bottomInset = -containerSizeThatFits(insetSize).height - Constants.containerInsets.bottom
    }

    private func layoutAnimated() {
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: [], animations: {
            self.view.layoutIfNeeded()
        })
    }

    // MARK: - Selectors

    @objc private func hide() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func actionButtonPressed(_ sender: UIButton) {
        actions[sender.tag].handler?()
        setInitialBottomInset()
        layoutAnimated()
        hide()
    }
}

extension UIView {

    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}
