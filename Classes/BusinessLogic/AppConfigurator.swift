//
//  Created by Alexander Gulin on 03/02/2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import Framezilla
import Fabric
import Crashlytics

final class AppConfigurator {

    static func configure(_ application: UIApplication, with launchOptions: LaunchOptions?) {
        let appVersion = "\(Bundle.main.appVersion) (\(Bundle.main.bundleVersion))"
        UserDefaults.standard.appVersion = appVersion
        Fabric.with([Crashlytics.self])

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.barTintColor = UIColor.sea
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.shadowImage = UIImage()

        let barButtonItemAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        barButtonItemAppearance.setTitleTextAttributes(StringAttributes.backButtonTextAttributes, for: .normal)
    }
}

private extension UserDefaults {

    var appVersion: String? {
        get {
            return string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
