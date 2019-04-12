//
//  UIViewController+PresentAlert.swift
//  ZenBudget
//
//  Created by Александр on 1.04.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: Bundle.main.appName,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: handler))
        present(alertController, animated: true)
    }
}
