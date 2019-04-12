//
//  AppDelegate.swift
//  ZenBudget
//
//  Created by Александр on 19.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppConfigurator.configure(application, with: launchOptions)
        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = NavigationController()
        let launchViewController = LaunchViewController(dependencies: Services)
        navigationController.viewControllers = [launchViewController]

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
