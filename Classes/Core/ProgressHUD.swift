//
//  ProgressHUD.swift
//  ZenBudget
//
//  Created by Александр on 22/03/2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import MBProgressHUD

typealias ProgressHUD = MBProgressHUD

extension ProgressHUD {

    @discardableResult
    static func show(addedTo view: UIView? = nil, animated: Bool = true) -> ProgressHUD? {
        guard let containerView = view ?? UIApplication.shared.keyWindow else {
            return nil
        }
        let hud = MBProgressHUD(view: containerView)
        hud.removeFromSuperViewOnHide = true
        containerView.addSubview(hud)
        hud.show(animated: true)
        return hud
    }

    @discardableResult
    static func showSuccess(addedTo view: UIView? = nil, animated: Bool = true) -> ProgressHUD? {
        guard let containerView = view ?? UIApplication.shared.keyWindow else {
            return nil
        }
        let hud = MBProgressHUD(view: containerView)
        hud.customView = UIImageView(image: UIImage(named: "hudCheckmark"))
        hud.removeFromSuperViewOnHide = true
        hud.mode = .customView
        containerView.addSubview(hud)
        hud.show(animated: animated)
        hud.hide(animated: animated, afterDelay: 1.5)
        return hud
    }
}
