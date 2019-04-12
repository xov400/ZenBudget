//
//  LaunchViewController.swift
//  ZenBudget
//
//  Created by Александр on 1.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class LaunchViewController: UIViewController {

    // MARK: - Properties

    typealias Dependencies = HasSessionService & HasProfileService
    let dependencies: Dependencies

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = UIColor.gray
        return indicator
    }()

    // MARK: - Life cycle

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(false)
        view.backgroundColor = UIColor.white
        view.addSubview(activityIndicatorView)
        if dependencies.sessionService.isAuthorized {
            sendMeRequest()
        } else {
            pushLoginViewController()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.configureFrame { maker in
            maker.center()
        }
    }

    // MARK: - Me request

    private func sendMeRequest() {
        activityIndicatorView.startAnimating()
        dependencies.profileService.sendMeRequest(success: { _ in
            self.activityIndicatorView.stopAnimating()
            let homeViewController = HomeViewController(dependencies: Services)
            self.navigationController?.setViewControllers([homeViewController], animated: true)
        }, failure: { error in
            self.activityIndicatorView.stopAnimating()
            if case GeneralRequestError.unauthorized = error {
                self.pushLoginViewController()
            } else if let generalRequestError = error as? GeneralRequestError {
                self.presentAlert(message: generalRequestError.localizedDescription, handler: { _ in
                    self.pushLoginViewController()
                })
            }
        })
    }

    private func pushLoginViewController() {
        let loginViewcontroller = LoginViewController(dependencies: Services)
        self.navigationController?.setViewControllers([loginViewcontroller], animated: true)
    }
}
