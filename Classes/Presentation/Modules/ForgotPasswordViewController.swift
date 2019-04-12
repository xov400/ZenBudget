//
//  ForgotPasswordViewController.swift
//  ZenBudget
//
//  Created by Александр on 21.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import Framezilla

final class ForgotPasswordViewController: UIViewController {

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

    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "ЗАБЫЛИ ПАРОЛЬ?", attributes: StringAttributes.headerTextAttributes)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Не беда. Укажите ваш адрес электронной почты и мы отправим вам пароль."
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

    private lazy var sendRequestButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.attributedText = NSAttributedString(string: "ОТПРАВИТЬ", attributes: StringAttributes.headerTextAttributes)
        button.setTitle("ОТПРАВИТЬ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.sea, for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .highlighted)
        button.setTitleColor(UIColor.sea.withAlphaComponent(0.5), for: .disabled)
        button.setBackgroundImage(UIImage.colored(UIColor.white.withAlphaComponent(0.5)), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendRequestButtonPressed), for: .touchUpInside)
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
        let views = [logoImageView, zenBudgetLabel, forgotPasswordLabel, messageLabel, mailTextField,
                     emailErrorLabel, sendRequestButton, activityIndicatorView]
        let container = views.container(in: scrollView) {
            logoImageView.configureFrame { maker in
                maker.centerX().top()
                maker.size(width: 30, height: 30)
            }
            zenBudgetLabel.configureFrame { maker in
                maker.sizeToFit()
                maker.top(to: logoImageView.nui_bottom, inset: 12).centerX()
            }
            forgotPasswordLabel.configureFrame { maker in
                maker.sizeToFit()
                maker.top(to: zenBudgetLabel.nui_bottom, inset: height * 0.05).centerX()
            }
            messageLabel.configureFrame { maker in
                maker.width(220).heightToFit()
                maker.top(to: forgotPasswordLabel.nui_bottom, inset: height * 0.06).centerX()
            }
            mailTextField.configureFrame { maker in
                maker.size(width: 220, height: 34)
                maker.top(to: messageLabel.nui_bottom, inset: 10).centerX()
            }
            emailErrorLabel.configureFrame { maker in
                maker.height(16).width(scrollView.bounds.width)
                maker.top(to: mailTextField.nui_bottom, inset: 10).centerX()
            }
            sendRequestButton.configureFrame { maker in
                maker.size(width: 220, height: 45)
                maker.top(to: mailTextField.nui_bottom, inset: height * 0.09).centerX()
            }
            activityIndicatorView.configureFrame { maker in
                maker.top(to: sendRequestButton.nui_bottom, inset: 35).centerX()
            }
        }
        container.configureFrame { maker in
            maker.centerX().top(inset: height * 0.07)
        }
        showLoginButton.configureFrame { maker in
            maker.height(32).widthToFit()
            maker.top(inset: height * 0.9).centerX()
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
            let signInButtonFrame = scrollView.convert(sendRequestButton.frame, from: sendRequestButton.superview)
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

    @objc private func sendRequestButtonPressed(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        sendRequestButton.isEnabled = false
        guard let email = mailTextField.text else {
            return
        }
        let parameters = ForgotPasswordParameters(email: email)
        dependencies.authService.resetPassword(parameters: parameters, success: { message in
            self.activityIndicatorView.stopAnimating()
            self.sendRequestButton.isEnabled = true
            self.showSuccessAlert(message: message)
        }, failure: { error in
            if let generalRequestError = error as? GeneralRequestError {
                let alertController = UIAlertController(title: Bundle.main.appName,
                                                        message: generalRequestError.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                self.present(alertController, animated: true)
            } else if let authEndpointError = error as? AuthEndpointError {
                if let emailErrorArray = authEndpointError.errors.email {
                    self.emailErrorLabel.text = emailErrorArray[0]
                }
            }
            self.activityIndicatorView.stopAnimating()
            self.sendRequestButton.isEnabled = true
        })
    }

    private func showSuccessAlert(message: String) {
        let alertController = UIAlertController(title: Bundle.main.appName, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: { _ in
                                                    self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Проверить почту",
                                                style: .default,
                                                handler: { _ in
                                                    let url = URL(string: "message://")!
                                                    if UIApplication.shared.canOpenURL(url) {
                                                        UIApplication.shared.open(url)
                                                    }
                                                    self.navigationController?.popViewController(animated: false)
        }))
        self.present(alertController, animated: true)
    }

    @objc private func returnToLoginButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Validate user input

    private func validateInput() {
        if let email = mailTextField.text, email.isValidEmail {
            sendRequestButton.isEnabled = true
        } else {
            sendRequestButton.isEnabled = false
        }
    }

    // MARK: - Text field controls

    @objc private func textFieldDidChange(textField: UITextField) {
        validateInput()
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }
}
