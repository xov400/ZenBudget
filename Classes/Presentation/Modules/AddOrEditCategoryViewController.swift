//
//  AddOrEditCategoryViewController.swift
//  ZenBudget
//
//  Created by Александр on 16.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import DropDown

final class AddOrEditCategoryViewController: UIViewController {

    // MARK: - Properties

    typealias Dependencies = HasAuthService & HasKindsService & HasCategoriesService
    private let dependencies: Dependencies

    private let isAddCategory: Bool

    weak var delegate: ChildViewControllerDelegate?
    var editableCategory: Category?
    private var kinds: [Category.Kind]?

    private enum Constants {
        static let viewsWidth = 220
        static let textFieldsHeight = 28
        static let amountLabelInset = 32
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        if isAddCategory {
            label.text = "Новая категория"
        } else {
            label.text = "Редактирование"
        }
        label.font = UIFont.appFont(size: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()

    private lazy var exitButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "close"),
                                     style: UIBarButtonItem.Style.plain,
                                     target: self, action: #selector(closeButtonPressed))
        button.tintColor = UIColor.black
        return button
    }()

    private(set) lazy var nameTextField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Название",
                                                             attributes: StringAttributes.textFieldRecordPlaceholderAttributes)
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.lineColor = UIColor.black.withAlphaComponent(0.4)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()

    private lazy var kindLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "Тип"
        return label
    }()

    private lazy var kindDropDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Polygon"), for: .normal)
        button.addTarget(self, action: #selector(typeDropDownButtonPressed), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        return button
    }()

    private lazy var kindDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = kindTextField
        dropDown.selectionAction = { [unowned self] index, item in
            if let kinds = self.kinds {
                let kind = kinds[index]
                self.kindTextField.text = kind.name
                self.descriptionLabel.text = kind.description
                if kind.id == 3 {
                    self.targetLabel.isHidden = false
                    self.targetTextField.isHidden = false
                } else {
                    self.targetLabel.isHidden = true
                    self.targetTextField.isHidden = true
                }
                self.layoutDescriptionLabel()
            }
        }
        dropDown.direction = .bottom
        return dropDown
    }()

    private(set) lazy var kindTextField: TextField = {
        let textField = TextField()
        textField.textColor = .black
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.lineColor = UIColor.black.withAlphaComponent(0.4)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.rightView = kindDropDownButton
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = 220
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "План в месяц"
        return label
    }()

    private lazy var amountTextFieldRightViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "р."
        return label
    }()

    private(set) lazy var amountTextField: TextField = {
        let textField = TextField()
        textField.textColor = .black
        textField.borderStyle = .none
        textField.keyboardType = .numbersAndPunctuation
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.lineColor = UIColor.black.withAlphaComponent(0.4)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.rightView = amountTextFieldRightViewLabel
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var targetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "Цель"
        label.isHidden = true
        return label
    }()

    private lazy var targetTextFieldRightViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "р."
        return label
    }()

    private(set) lazy var targetTextField: TextField = {
        let textField = TextField()
        textField.textColor = .black
        textField.borderStyle = .none
        textField.keyboardType = .numbersAndPunctuation
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.lineColor = UIColor.black.withAlphaComponent(0.4)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.rightView = targetTextFieldRightViewLabel
        textField.rightViewMode = .always
        textField.isHidden = true
        return textField
    }()

    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        if isAddCategory {
            button.setTitle("ДОБАВИТЬ", for: .normal)
        } else {
            button.setTitle("ИЗМЕНИТЬ", for: .normal)
        }
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.sea), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.sea.withAlphaComponent(0.5)), for: .highlighted)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        button.setBackgroundImage(UIImage.colored(UIColor.sea.withAlphaComponent(0.5)), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.isEnabled = false
        tapRecognizer.cancelsTouchesInView = false
        return tapRecognizer
    }()

    // MARK: - Life cycle

    init(dependencies: Dependencies, isAddCategory: Bool) {
        self.dependencies = dependencies
        self.isAddCategory = isAddCategory
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
        navigationItem.setRightBarButton(exitButton, animated: true)
        navigationItem.titleView = titleLabel

        scrollView.addSubview(addCategoryButton)
        view.addSubview(scrollView)
        view.addGestureRecognizer(tapRecognizer)

        validateInput()

        view.setNeedsLayout()
        view.layoutIfNeeded()

        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated)

        // I think this is bad (show to mentor)
        navigationController?.navigationBar.barTintColor = UIColor.white

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    var container = UIView()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.configureFrame { maker in
            maker.equal(to: view)
        }
        let height = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        let views = [nameTextField, kindLabel, kindTextField, descriptionLabel,
                     amountLabel, amountTextField, targetLabel, targetTextField]
        configureContainer(height: height, views: views).configureFrame { maker in
            maker.centerX().top(inset: height * 0.09)
        }
        kindDropDownButton.configureFrame { maker in
            maker.sizeToFit()
        }
        amountTextFieldRightViewLabel.configureFrame { maker in
            maker.sizeToFit()
        }

        kindDropDown.width = kindTextField.bounds.width
        kindDropDown.bottomOffset = CGPoint(x: 0, y: kindTextField.bounds.height)

        addCategoryButton.configureFrame { maker in
            maker.size(width: Constants.viewsWidth, height: 45).top(inset: height * 0.83).centerX()
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: addCategoryButton.frame.maxY)
    }

    private func configureContainer(height: CGFloat, views: [UIView]) -> UIView {
        container = views.container(in: scrollView) {
            nameTextField.configureFrame { maker in
                maker.size(width: Constants.viewsWidth, height: Constants.textFieldsHeight).left().top()
            }
            kindLabel.configureFrame { maker in
                maker.sizeToFit().left().top(to: nameTextField.nui_bottom, inset: height * 0.05)
            }
            kindTextField.configureFrame { maker in
                maker.size(width: Constants.viewsWidth, height: Constants.textFieldsHeight).top(to: kindLabel.nui_bottom).centerX()
            }
            descriptionLabel.configureFrame { maker in
                maker.width(Constants.viewsWidth).heightToFit()
                maker.top(to: kindTextField.nui_bottom, inset: height * 0.02).centerX()
            }
            amountLabel.configureFrame { maker in
                maker.sizeToFit().left().top(to: descriptionLabel.nui_bottom, inset: Constants.amountLabelInset)
            }
            amountTextField.configureFrame { maker in
                maker.size(width: Constants.viewsWidth, height: Constants.textFieldsHeight)
                maker.top(to: amountLabel.nui_bottom).centerX()
            }
            targetLabel.configureFrame { maker in
                maker.sizeToFit().left().top(to: amountTextField.nui_bottom, inset: Constants.amountLabelInset)
            }
            targetTextField.configureFrame { maker in
                maker.size(width: Constants.viewsWidth, height: Constants.textFieldsHeight)
                maker.top(to: targetLabel.nui_bottom).centerX()
            }
        }
        return container
    }

    private func layoutDescriptionLabel() {
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.sizeToFit()
            self.view.layoutIfNeeded()
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // I think this is bad (show to mentor)
        navigationController?.navigationBar.barTintColor = UIColor.sea

        NotificationCenter.default.removeObserver(self) // swiftlint:disable:this notification_center_detachment
    }

    // MARK: - Fetch data

    private func fetchData() {
        guard let kindsDataResponse = dependencies.kindsService.kindsDataResponse else {
            return
        }
        filterKinds(kindsDataResponse: kindsDataResponse)
        guard let kinds = self.kinds else {
            return
        }
        self.kindDropDown.dataSource = kinds.map { $0.name }

        if isAddCategory {
            self.kindDropDown.selectRow(0)
            if let firstKind = kinds.first {
                self.kindTextField.text = firstKind.name
                self.descriptionLabel.text = firstKind.description
                self.layoutDescriptionLabel()
            }
        } else {
            if let editableCategory = editableCategory, let kind = editableCategory.kind {
                self.nameTextField.text = editableCategory.name
                self.kindTextField.text = kind.name
                self.descriptionLabel.text = kind.description
                self.amountTextField.text = String(editableCategory.amount)
                if kind.id == 3, let extra = editableCategory.extra, let target = extra.goal {
                    self.targetLabel.isHidden = false
                    self.targetTextField.isHidden = false
                    self.targetTextField.text = String(target)
                }
                self.layoutDescriptionLabel()
            }
        }
        validateInput()
    }

    private func filterKinds(kindsDataResponse: KindsDataResponse) {
        self.kinds = kindsDataResponse.kinds.compactMap { kind -> Category.Kind? in
            if self.isAddCategory, kind.isCategoryCreatable {
                return kind
            }
            if !self.isAddCategory, kind.isCategoryEditable {
                return kind
            }
            return nil
        }
    }

    // MARK: - Showing keyboard

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        scrollView.delaysContentTouches = true
        tapRecognizer.isEnabled = true
        if let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let addRecordButtonFrame = scrollView.convert(amountTextField.frame, from: amountTextField.superview)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 16, right: 0)
            scrollView.contentOffset = CGPoint(x: 0, y: max(0, addRecordButtonFrame.maxY - keyboardFrame.minY + 16))
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

    @objc private func addCategoryButtonPressed(_ sender: UIButton) {
        addCategoryButton.isEnabled = false

        guard let categoryName = nameTextField.text,
            let amountString = amountTextField.text,
            let amount = Double(amountString) else {
                return
        }

        var target = amount
        if let targetString = targetTextField.text, let doubleTarget = Double(targetString) {
            target = doubleTarget
        }

        if isAddCategory {
            guard let kindIndex = kindDropDown.indexForSelectedRow, let kinds = kinds else {
                return
            }
            let selectedKind = kinds[kindIndex]
            let addCategoryParameters = AddCategoryParameters(categoryName: categoryName,
                                                              kindID: selectedKind.id,
                                                              amount: amount,
                                                              goal: target)
            addCategoryRequest(parameters: addCategoryParameters)
        } else {
            guard let editableCategory = editableCategory else {
                return
            }
            let editCategoryParameters = EditCategoryParameters(name: categoryName, amount: amount, goal: target)
            editCategoryRequest(categoryID: editableCategory.id, parameters: editCategoryParameters)
        }
    }

    private func addCategoryRequest(parameters: AddCategoryParameters) {
        let hud = ProgressHUD.show(animated: true)
        dependencies.categoriesService.addCategory(parameters: parameters, success: { message in
            hud?.hide(animated: true)
            self.addCategoryButton.isEnabled = true
            self.dismissViewController()
        }, failure: { error in
            hud?.hide(animated: true)
            self.addCategoryButton.isEnabled = true
            if let generalRequestError = error as? GeneralRequestError {
                self.presentAlert(message: generalRequestError.localizedDescription, handler: { _ in
                    self.dismissToLoginViewController()
                })
            } else if let propertiesCategoryError = error as? FieldsCategoryError {
                if let nameErrorArray = propertiesCategoryError.errors.name {
                    self.presentAlert(message: nameErrorArray[0])
                }
                if let typeIDErrorArray = propertiesCategoryError.errors.typeID {
                    self.presentAlert(message: typeIDErrorArray[0])
                }
                if let amountErrorArray = propertiesCategoryError.errors.amount {
                    self.presentAlert(message: amountErrorArray[0])
                }
            } else if let resourcesCategoryError = error as? ResourcesCategoryError {
                self.presentAlert(message: resourcesCategoryError.error)
            }
        })
    }

    private func editCategoryRequest(categoryID: UInt64, parameters: EditCategoryParameters) {
        let hud = ProgressHUD.show(animated: true)
        dependencies.categoriesService.editCategory(categoryID: categoryID, parameters: parameters, success: { message in
            hud?.hide(animated: true)
            self.addCategoryButton.isEnabled = true
            self.dismissViewController()
        }, failure: { error in
            hud?.hide(animated: true)
            self.addCategoryButton.isEnabled = true
            if let generalRequestError = error as? GeneralRequestError {
                self.presentAlert(message: generalRequestError.localizedDescription, handler: { _ in
                    self.dismissToLoginViewController()
                })
            } else if let propertiesCategoryError = error as? FieldsCategoryError {
                if let nameErrorArray = propertiesCategoryError.errors.name {
                    self.presentAlert(message: nameErrorArray[0])
                }
                if let typeIDErrorArray = propertiesCategoryError.errors.typeID {
                    self.presentAlert(message: typeIDErrorArray[0])
                }
                if let amountErrorArray = propertiesCategoryError.errors.amount {
                    self.presentAlert(message: amountErrorArray[0])
                }
            } else if let resourcesCategoryError = error as? ResourcesCategoryError {
                self.presentAlert(message: resourcesCategoryError.error)
            }
        })
    }

    private func dismissViewController() {
        if let settingsViewController = delegate {
            settingsViewController.wasChanged()
        }
        dismiss(animated: true)
    }

    @objc private func typeDropDownButtonPressed(_ sender: UIButton) {
        if isAddCategory {
            kindDropDown.show()
        }
    }

    private func dismissToLoginViewController() {
        let loginViewcontroller = LoginViewController(dependencies: Services)
        let rootNavigationController = navigationController?.presentingViewController as? UINavigationController
        rootNavigationController?.setViewControllers([loginViewcontroller], animated: false)
        dismiss(animated: true)
    }

    // MARK: - Validate user input

    private func validateInput() {
        if let amount = amountTextField.text, Double(amount) != 0.0, amount.isValidAmount {
            addCategoryButton.isEnabled = true
        } else {
            addCategoryButton.isEnabled = false
        }
    }

    // MARK: - TextField controls

    @objc private func textFieldDidChange(_ sender: UITextField) {
        validateInput()
    }
}

extension AddOrEditCategoryViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === kindTextField {
            return false
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === amountTextField {
            if string.isEmpty {
                return true
            }
            return string.rangeOfCharacter(from: CharacterSet.legalAmountSymbols) != nil
        }
        return string.rangeOfCharacter(from: CharacterSet.newlines) == nil
    }
}
