//
//  SignUpViewController.swift
//  ZenBudget
//
//  Created by Александр on 21.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class SignUpViewController: UIViewController {

    // MARK: - Properties

    typealias Dependencies = HasAuthService
    private let dependencies: Dependencies

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
        label.textColor = UIColor.white
        return label
    }()

    private lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "РЕГИСТРАЦИЯ", attributes: StringAttributes.headerTextAttributes)
        label.textAlignment = .center
        label.textColor = UIColor.white
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

    private lazy var emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.white
        return label
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

    private lazy var passwordConfirmationTextField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Пароль еще раз",
                                                             attributes: StringAttributes.textFieldAuthPlaceholderAttributes)
        textField.textColor = .white
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var passwordConfirmationErrorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.white
        return label
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.attributedText = NSAttributedString(string: "СОЗДАТЬ АККАУНТ", attributes: StringAttributes.headerTextAttributes)
        button.setTitle("СОЗДАТЬ АККАУНТ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.sea, for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .highlighted)
        button.setTitleColor(UIColor.sea.withAlphaComponent(0.5), for: .disabled)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(createAccountButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        return indicator
    }()

    private lazy var showLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход", for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = UIFont.appFont(size: 15)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(returnToLoginButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.isEnabled = false
        tapRecognizer.cancelsTouchesInView = true
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
        scrollView.addSubview(showLoginButton)
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
            logoImageView, zenBudgetLabel, registrationLabel, mailTextField, emailErrorLabel,
            passwordTextField, passwordErrorLabel, passwordConfirmationTextField, passwordConfirmationErrorLabel,
            createAccountButton, activityIndicatorView
        ]
        let container = views.container(in: scrollView) {
            logoImageView.configureFrame { maker in
                maker.centerX().top().size(width: 30, height: 30)
            }
            zenBudgetLabel.configureFrame { maker in
                maker.sizeToFit().top(to: logoImageView.nui_bottom, inset: 12).centerX()
            }
            registrationLabel.configureFrame { maker in
                maker.sizeToFit().top(to: zenBudgetLabel.nui_bottom, inset: height * 0.05).centerX()
            }
            mailTextField.configureFrame { maker in
                maker.size(width: 220, height: 34).top(to: registrationLabel.nui_bottom, inset: height * 0.06).centerX()
            }
            emailErrorLabel.configureFrame { maker in
                maker.height(16).width(scrollView.bounds.width).top(to: mailTextField.nui_bottom, inset: 10).centerX()
            }
            passwordTextField.configureFrame { maker in
                maker.size(width: 220, height: 34).top(to: mailTextField.nui_bottom, inset: 28).centerX()
            }
            passwordErrorLabel.configureFrame { maker in
                maker.height(16).width(scrollView.bounds.width).top(to: passwordTextField.nui_bottom, inset: 10).centerX()
            }
            passwordConfirmationTextField.configureFrame { maker in
                maker.size(width: 220, height: 34).top(to: passwordTextField.nui_bottom, inset: 28).centerX()
            }
            passwordConfirmationErrorLabel.configureFrame { maker in
                maker.height(16).width(scrollView.bounds.width).top(to: passwordConfirmationTextField.nui_bottom, inset: 10).centerX()
            }
            createAccountButton.configureFrame { maker in
                maker.size(width: 220, height: 45).top(to: passwordConfirmationTextField.nui_bottom, inset: height * 0.07).centerX()
            }
            activityIndicatorView.configureFrame { maker in
                maker.top(to: createAccountButton.nui_bottom, inset: 35).centerX()
            }
        }
        container.configureFrame { maker in
            maker.centerX().top(inset: height * 0.07)
        }
        showLoginButton.configureFrame { maker in
            maker.height(32).widthToFit().top(inset: height * 0.9).centerX()
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: showLoginButton.frame.maxY)
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
            let signInButtonFrame = scrollView.convert(createAccountButton.frame, from: createAccountButton.superview)
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

    @objc func createAccountButtonPressed(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        createAccountButton.isEnabled = false
        guard let email = mailTextField.text,
            let password = passwordTextField.text,
            let passwordConfirmation = passwordConfirmationTextField.text else {
                return
        }
        let signUpParameters = SignUpParameters(email: email, password: password, passwordConfirmation: passwordConfirmation)
        dependencies.authService.register(parameters: signUpParameters, success: {
            self.activityIndicatorView.stopAnimating()
            self.createAccountButton.isEnabled = true
            let homeViewController = HomeViewController(dependencies: Services)
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }, failure: { error in
            if let generalRequestError = error as? GeneralRequestError {
                self.presentAlert(message: generalRequestError.localizedDescription)
            } else if let authEndpointError = error as? AuthEndpointError {
                if let emailErrorArray = authEndpointError.errors.email {
                    self.emailErrorLabel.text = emailErrorArray[0]
                }
                if let passwordErrorArray = authEndpointError.errors.password {
                    self.passwordErrorLabel.text = passwordErrorArray[0]
                }
            }
            self.activityIndicatorView.stopAnimating()
            self.createAccountButton.isEnabled = true
            print(error)
        })
    }

    @objc func returnToLoginButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Validate user input

    private func validateInput() {
        if let email = mailTextField.text, let password = passwordTextField.text, let passwordConfirmation = passwordConfirmationTextField.text {
            let emailIsValid = email.isValidEmail
            let passwordIsValid = validatePassword(password: password)
            let passwordConfirmationIsValid = validatePasswordConfirmation(password: password, passwordConfirmation: passwordConfirmation)
            createAccountButton.isEnabled = emailIsValid && passwordIsValid && passwordConfirmationIsValid
        } else {
            createAccountButton.isEnabled = false
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

    private func validatePasswordConfirmation(password: String, passwordConfirmation: String) -> Bool {
        if passwordConfirmation == password {
            passwordConfirmationErrorLabel.text?.removeAll()
            return true
        } else {
            passwordConfirmationErrorLabel.text = "Пароль и подтверждение должны быть одинаковы"
        }
        return false
    }

    // MARK: - Text field controls

    @objc private func textFieldDidChange(textField: UITextField) {
        validateInput()
    }
}

extension SignUpViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === passwordTextField, let password = textField.text, !password.isValidPassword {
            passwordErrorLabel.text = "Пароль должен быть не менее 6 символов"
        }
        if textField === passwordConfirmationTextField, let passwordConfirmation = textField.text,
            let password = passwordTextField.text, passwordConfirmation != password {
            passwordConfirmationErrorLabel.text = "Пароль и подтверждение должны быть одинаковы"
        }
    }
}
