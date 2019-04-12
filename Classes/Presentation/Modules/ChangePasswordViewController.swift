//
//  ChangePasswordViewController.swift
//  ZenBudget
//
//  Created by Александр on 16.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import DropDown

final class ChangePasswordViewController: UIViewController {

    // MARK: - Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    typealias Dependencies = HasAuthService
    private let dependencies: Dependencies

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Смена пароля"
        label.font = UIFont.appFont(size: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()

    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "close"),
                                     style: UIBarButtonItem.Style.plain,
                                     target: self, action: #selector(closeButtonPressed))
        button.tintColor = UIColor.black
        return button
    }()

    private(set) lazy var oldPasswordTextField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Старый пароль",
                                                             attributes: StringAttributes.textFieldRecordPlaceholderAttributes)
        configureTextField(textField: textField)
        return textField
    }()

    private lazy var oldPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.persimmon
        label.numberOfLines = 0
        return label
    }()

    private(set) lazy var newPasswordTextField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Новый пароль",
                                                             attributes: StringAttributes.textFieldRecordPlaceholderAttributes)
        configureTextField(textField: textField)
        return textField
    }()

    private lazy var newPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.persimmon
        label.numberOfLines = 0
        return label
    }()

    private(set) lazy var confirmationTextField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Пароль еще раз",
                                                             attributes: StringAttributes.textFieldRecordPlaceholderAttributes)
        configureTextField(textField: textField)
        return textField
    }()

    private func configureTextField(textField: TextField) {
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.lineColor = UIColor.black.withAlphaComponent(0.4)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private lazy var confirmationErrorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.persimmon
        label.numberOfLines = 0
        return label
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = UIColor.gray
        return indicator
    }()

    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.attributedText = NSAttributedString(string: "СМЕНИТЬ ПАРОЛЬ", attributes: StringAttributes.headerTextAttributes)
        button.setTitle("СМЕНИТЬ ПАРОЛЬ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.sea), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.sea.withAlphaComponent(0.5)), for: .highlighted)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        button.setBackgroundImage(UIImage.colored(UIColor.sea.withAlphaComponent(0.5)), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
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
        view.backgroundColor = UIColor.white

        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setRightBarButton(closeBarButtonItem, animated: true)
        navigationItem.titleView = titleLabel

        scrollView.addSubview(changePasswordButton)
        view.addSubview(scrollView)
        view.addSubview(activityIndicatorView)
        view.addGestureRecognizer(tapRecognizer)

        validateInput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated)

        navigationController?.navigationBar.barTintColor = UIColor.white

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

        let views = [oldPasswordTextField, oldPasswordErrorLabel,
                     newPasswordTextField, newPasswordErrorLabel,
                     confirmationTextField, confirmationErrorLabel]
        let container = views.container(in: scrollView) {
            oldPasswordTextField.configureFrame { maker in
                maker.size(width: 220, height: 28).centerX().top()
            }
            oldPasswordErrorLabel.configureFrame { maker in
                maker.heightToFit().width(220).top(to: oldPasswordTextField.nui_bottom, inset: 10).centerX()
            }
            newPasswordTextField.configureFrame { maker in
                maker.size(width: 220, height: 28).centerX().top(to: oldPasswordTextField.nui_bottom, inset: height * 0.08)
            }
            newPasswordErrorLabel.configureFrame { maker in
                maker.heightToFit().width(220).top(to: newPasswordTextField.nui_bottom, inset: 10).centerX()
            }
            confirmationTextField.configureFrame { maker in
                maker.size(width: 220, height: 28).centerX().top(to: newPasswordTextField.nui_bottom, inset: height * 0.08)
            }
            confirmationErrorLabel.configureFrame { maker in
                maker.heightToFit().width(220).top(to: confirmationTextField.nui_bottom, inset: 10).centerX()
            }
        }

        container.configureFrame { maker in
            maker.centerX().top(inset: height * 0.09)
        }
        changePasswordButton.configureFrame { maker in
            maker.size(width: 220, height: 45).top(inset: height * 0.83).centerX()
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: changePasswordButton.frame.maxY)
        guard let topInsetForActivityIndicator = navigationController?.navigationBar.bounds.height else {
            return
        }
        activityIndicatorView.configureFrame { maker in
            maker.centerX().centerY(offset: topInsetForActivityIndicator)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.barTintColor = UIColor.sea

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
            let confirmationTextFieldFrame = scrollView.convert(confirmationTextField.frame, from: confirmationTextField.superview)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 16, right: 0)
            scrollView.contentOffset = CGPoint(x: 0, y: max(0, confirmationTextFieldFrame.maxY - keyboardFrame.minY + 16))
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.delaysContentTouches = false
        tapRecognizer.isEnabled = false
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentInset = .zero
    }

    // MARK: - Button controls

    @objc private func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc private func changePasswordButtonPressed(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        changePasswordButton.isEnabled = false
        guard let newPassword = newPasswordTextField.text,
            let oldPassword = oldPasswordTextField.text,
            let confirmation = confirmationTextField.text else {
                return
        }
        let parameters = UpdatePasswordParameters(oldPassword: oldPassword, newPassword: newPassword, passwordConfirmation: confirmation)
        dependencies.authService.updatePassword(parameters: parameters, success: { message in
            self.activityIndicatorView.stopAnimating()
            self.changePasswordButton.isEnabled = true
            self.presentAlert(message: message, handler: { _ in
                self.dismiss(animated: true)
            })
        }, failure: { error in
            self.activityIndicatorView.stopAnimating()
            self.changePasswordButton.isEnabled = true
            if case GeneralRequestError.unauthorized = error {
                self.presentAlert(message: error.localizedDescription, handler: { _ in
                    let loginViewcontroller = LoginViewController(dependencies: Services)
                    self.navigationController?.setViewControllers([loginViewcontroller], animated: true)
                })
            } else if let generalRequestError = error as? GeneralRequestError {
                self.presentAlert(message: generalRequestError.localizedDescription)
            } else if let updatePasswordError = error as? UpdatePasswordError {
                self.presentAlert(message: updatePasswordError.reason)
            }
        })
    }

    // MARK: - Validate user input

    var oldPasswordTextFieldWasEditing = false
    var newPasswordTextFieldWasEditing = false
    var confirmationTextFieldWasEditing = false
    private func validateInput() {
        if let password = oldPasswordTextField.text,
            let newPassword = newPasswordTextField.text,
            let passwordConfirmation = confirmationTextField.text {

            let passwordIsValid = validatePassword(password: password)
            let newPasswordIsValid = validateNewPassword(password: password, newPassword: newPassword)
            let passwordConfirmationIsValid = validatePasswordConfirmation(password: newPassword,
                                                                           passwordConfirmation: passwordConfirmation)
            changePasswordButton.isEnabled = passwordIsValid && newPasswordIsValid && passwordConfirmationIsValid
        } else {
            changePasswordButton.isEnabled = false
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    private func validatePassword(password: String) -> Bool {
        if password.isValidPassword {
            oldPasswordErrorLabel.text?.removeAll()
            return true
        } else if oldPasswordTextFieldWasEditing {
            oldPasswordErrorLabel.text = "Пароль должен быть не менее 6 символов, содержать буквы и цифры"
        }
        return false
    }

    private func validateNewPassword(password: String, newPassword: String) -> Bool {
        if password == newPassword, newPasswordTextFieldWasEditing {
            newPasswordErrorLabel.text = "Новый пароль должен отличаться от старого"
            return false
        } else if newPassword.isValidPassword {
            newPasswordErrorLabel.text?.removeAll()
            return true
        } else if newPasswordTextFieldWasEditing {
            newPasswordErrorLabel.text = "Пароль должен быть не менее 6 символов, содержать буквы и цифры"
        }
        return false
    }

    private func validatePasswordConfirmation(password: String, passwordConfirmation: String) -> Bool {
        if passwordConfirmation == password {
            confirmationErrorLabel.text?.removeAll()
            return true
        } else if confirmationTextFieldWasEditing {
            confirmationErrorLabel.text = "Новый пароль и подтверждение должны быть одинаковы"
        }
        return false
    }

    // MARK: - Text field controls

    @objc private func textFieldDidChange(textField: UITextField) {
        validateInput()
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.whitespaces) == nil
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === oldPasswordTextField {
            oldPasswordTextFieldWasEditing = true
        }
        if textField === newPasswordTextField {
            newPasswordTextFieldWasEditing = true
        }
        if textField === confirmationTextField {
            confirmationTextFieldWasEditing = true
        }
    }
}
