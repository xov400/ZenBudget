//
//  NavigationController.swift
//  ZenBudget
//
//  Created by Александр on 19.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
