//
//  UIViewController+Navigation.swift
//  ZenBudget
//
//  Created by Александр on 22.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

extension UIViewController {

    func hideNavigationBar(_ animated: Bool) {
        if let navigationController = navigationController, !navigationController.isNavigationBarHidden {
            navigationController.setNavigationBarHidden(true, animated: animated)
        }
    }

    func showNavigationBar(_ animated: Bool) {
        if let navigationController = navigationController, navigationController.isNavigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }

    func hideBackButton(_ animated: Bool) {
        if let navigationController = navigationController {
            navigationController.navigationItem.setHidesBackButton(true, animated: animated)
        }
    }
}
