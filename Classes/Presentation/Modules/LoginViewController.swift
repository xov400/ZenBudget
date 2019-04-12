//
//  LoginViewController.swift
//  ZenBudget
//
//  Created by Александр on 19.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class LoginViewController: UIViewController {

    // MARK: - Properties

    typealias Dependencies = HasAuthService & HasProfileService
    let dependencies: Dependencies

    var passwordWasEditing = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        return scrollView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()

    private lazy var zenBudgetLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "ZEN BUDGET", attributes: StringAttributes.headerTextAttributes)
        label.textAlignment = .center
        return label
    }()

    private lazy var mailTextField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Почта", attributes: StringAttributes.textFieldAuthPlaceholderAttributes)
        textField.textColor = .white
        textField.borderStyle = .none
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()

    private lazy var passwordTextField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: StringAttributes.textFieldAuthPlaceholderAttributes)
        textField.textColor = .white
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.white
        return label
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.attributedText = NSAttributedString(string: "ВОЙТИ", attributes: StringAttributes.headerTextAttributes)
        button.setTitle("ВОЙТИ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.sea, for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .highlighted)
        button.setTitleColor(UIColor.sea.withAlphaComponent(0.5), for: .disabled)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        return indicator
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль", for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = UIFont.appFont(size: 15)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = UIFont.appFont(size: 15)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(registrationButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.isEnabled = false
        tapRecognizer.cancelsTouchesInView = false
        return tapRecognizer
    }()

    // MARK: - Life cycle

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.sea
        #if DEBUG
//            mailTextField.text = "test04@email.com"
//            passwordTextField.text = "secret55"
        mailTextField.text = "test88@email.com"
        passwordTextField.text = "secret55"
        #endif
        scrollView.addSubview(forgotPasswordButton)
        scrollView.addSubview(registrationButton)
        view.addSubview(scrollView)
        view.addGestureRecognizer(tapRecognizer)
        validateInput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.configureFrame { maker in
            maker.equal(to: view)
        }
        let height = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        let views = [
            logoImageView, zenBudgetLabel, mailTextField, passwordTextField,
            passwordErrorLabel, signInButton, activityIndicatorView
        ]
        let container = views.container(in: scrollView) {
            logoImageView.configureFrame { maker in
                maker.centerX().top().size(width: 30, height: 30)
            }
            zenBudgetLabel.configureFrame { maker in
                maker.sizeToFit()
                maker.top(to: logoImageView.nui_bottom, inset: 12).centerX()
            }
            mailTextField.configureFrame { maker in
                maker.size(width: 220, height: 34)
                maker.top(to: zenBudgetLabel.nui_bottom, inset: height * 0.13).centerX()
            }
            passwordTextField.configureFrame { maker in
                maker.size(width: 220, height: 34)
                maker.top(to: mailTextField.nui_bottom, inset: 30).centerX()
            }
            passwordErrorLabel.configureFrame { maker in
                maker.height(16).width(scrollView.bounds.width)
                maker.top(to: passwordTextField.nui_bottom, inset: 10).centerX()
            }
            signInButton.configureFrame { maker in
                maker.size(width: 220, height: 45)
                maker.top(to: passwordTextField.nui_bottom, inset: height * 0.08).centerX()
            }
            activityIndicatorView.configureFrame { maker in
                maker.top(to: signInButton.nui_bottom, inset: 35).centerX()
            }
        }
        container.configureFrame { maker in
            maker.centerX().top(inset: height * 0.07)
        }
        registrationButton.configureFrame { maker in
            maker.height(32).widthToFit().top(inset: height * 0.9).centerX()
        }
        forgotPasswordButton.configureFrame { maker in
            maker.height(32).widthToFit()
            maker.bottom(to: registrationButton.nui_top, inset: 27).centerX()
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: registrationButton.frame.maxY)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // swiftlint:disable:this notification_center_detachment
    }

    // MARK: - Showing keyboard

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        scrollView.delaysContentTouches = true
        tapRecognizer.isEnabled = true
        if let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let signInButtonFrame = scrollView.convert(signInButton.frame, from: signInButton.superview)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 16, right: 0)
            scrollView.contentOffset = CGPoint(x: 0, y: max(0, signInButtonFrame.maxY - keyboardFrame.minY + 16))
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.delaysContentTouches = false
        tapRecognizer.isEnabled = false
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentInset = .zero
    }

    // MARK: - Button controls

    @objc private func signInButtonPressed(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        signInButton.isEnabled = false
        guard let email = mailTextField.text, let password = passwordTextField.text else {
            return
        }
        let parameters = LoginParameters(email: email, password: password)
        dependencies.authService.login(parameters: parameters, success: {
            self.sendMeRequest()
        }, failure: { error in
            if let generalRequestError = error as? GeneralRequestError {
                self.presentAlert(message: generalRequestError.localizedDescription)
            }
            self.activityIndicatorView.stopAnimating()
            self.signInButton.isEnabled = true
        })
    }

    private func sendMeRequest() {
        activityIndicatorView.startAnimating()
        dependencies.profileService.sendMeRequest(success: { _ in
            self.activityIndicatorView.stopAnimating()
            self.signInButton.isEnabled = true
            let homeViewController = HomeViewController(dependencies: Services)
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }, failure: { error in
            self.activityIndicatorView.stopAnimating()
            if case GeneralRequestError.unauthorized = error {
            } else if let generalRequestError = error as? GeneralRequestError {
                let alertController = UIAlertController(title: Bundle.main.appName,
                                                        message: generalRequestError.localizedDescription,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                }))
                self.present(alertController, animated: true)
            }
        })
    }

    @objc private func forgotPasswordButtonPressed(_ sender: UIButton) {
        let forgotPasswordViewController = ForgotPasswordViewController(dependencies: Services)
        navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }

    @objc private func registrationButtonPressed(_ sender: UIButton) {
        let signUpViewController = SignUpViewController(dependencies: Services)
        navigationController?.pushViewController(signUpViewController, animated: true)
    }

    // MARK: - Validate user input

    private func validateInput() {
        if let password = passwordTextField.text, validatePassword(password: password), let email = mailTextField.text, email.isValidEmail {
            signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
        }
    }

    private func validatePassword(password: String) -> Bool {
        if password.isValidPassword {
            passwordErrorLabel.text?.removeAll()
            return true
        } else if passwordTextField.isEditing {
            passwordErrorLabel.text = "Пароль должен быть не менее 6 символов"
        }
        return false
    }

    // MARK: - Text field controls

    @objc private func textFieldDidChange(textField: UITextField) {
        validateInput()
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === passwordTextField, let password = passwordTextField.text, !password.isValidPassword {
            passwordErrorLabel.text = "Пароль должен быть не менее 6 символов"
        }
    }
}
