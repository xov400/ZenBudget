//
//  AddRecordViewController.swift
//  ZenBudget
//
//  Created by Александр on 16.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import DropDown

final class AddRecordViewController: UIViewController {

    // MARK: - Properties

    typealias Dependencies = HasSessionService & HasAuthService & HasCategoriesService & HasOperationsService
    private let dependencies: Dependencies
    weak var delegate: ChildViewControllerDelegate?

    private var categoriesDataResponse: CategoriesDataResponse?
    private var categoriesData: [String] = []
    private var whereToGetData: [String] = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        return indicator
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая запись"
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

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "Категория"
        return label
    }()

    private lazy var caregoryDropDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Polygon"), for: .normal)
        button.addTarget(self, action: #selector(dropDownButtonPressed), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        return button
    }()

    private lazy var categoryDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = categoryTextField
        dropDown.selectionAction = { [unowned self] index, item in
            self.categoryTextField.text = item
            self.validateInput()
        }
        dropDown.direction = .bottom
        return dropDown
    }()

    private(set) lazy var categoryTextField: TextField = {
        let textField = TextField()
        textField.textColor = .black
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.lineColor = UIColor.black.withAlphaComponent(0.4)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.rightView = caregoryDropDownButton
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "Сумма"
        return label
    }()

    private lazy var ammountTextFieldRightViewLabel: UILabel = {
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
        textField.rightView = ammountTextFieldRightViewLabel
        textField.rightViewMode = .always
        return textField
    }()

    private(set) lazy var commentTextField: TextField = {
        let textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Комментарий",
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

    private lazy var amountErrorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.persimmon
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Недостаточно свободных средств. Придется взять недостающее из другого фонда"
        label.isHidden = true
        return label
    }()

    private lazy var whereToGetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.text = "Откуда взять"
        label.isHidden = true
        return label
    }()

    private lazy var whereToGetDropDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Polygon"), for: .normal)
        button.addTarget(self, action: #selector(dropDownButtonPressed), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        return button
    }()

    private lazy var whereToGetDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = whereToGetTextField
        dropDown.selectionAction = { [unowned self] index, item in
            self.whereToGetTextField.text = item
            self.validateInput()
        }
        dropDown.direction = .bottom
        dropDown.willShowAction = {
            self.whereToGetData = self.categoriesData
            if let indexForSelectedRow = self.categoryDropDown.indexForSelectedRow {
                self.whereToGetData.remove(at: indexForSelectedRow)
                dropDown.dataSource = self.whereToGetData
            }
        }
        return dropDown
    }()

    private(set) lazy var whereToGetTextField: TextField = {
        let textField = TextField()
        textField.textColor = .black
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.lineColor = UIColor.black.withAlphaComponent(0.4)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.rightView = whereToGetDropDownButton
        textField.rightViewMode = .always
        textField.isHidden = true
        return textField
    }()

    private lazy var addRecordButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.attributedText = NSAttributedString(string: "ДОБАВИТЬ", attributes: StringAttributes.headerTextAttributes)
        button.setTitle("ДОБАВИТЬ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.sea), for: .normal)
        button.setBackgroundImage(UIImage.colored(UIColor.sea.withAlphaComponent(0.5)), for: .highlighted)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        button.setBackgroundImage(UIImage.colored(UIColor.sea.withAlphaComponent(0.5)), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(addRecordButtonPressed), for: .touchUpInside)
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
        navigationItem.setRightBarButton(exitButton, animated: true)
        navigationItem.titleView = titleLabel

        scrollView.addSubview(addRecordButton)
        view.addSubview(scrollView)
        view.addSubview(activityIndicatorView)
        view.addGestureRecognizer(tapRecognizer)

        fetchData()
        validateInput()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.configureFrame { maker in
            maker.equal(to: view)
        }
        let height = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom

        collectContainer(viewHeight: height).configureFrame { maker in
            maker.centerX().top(inset: height * 0.07)
        }
        caregoryDropDownButton.configureFrame { maker in
            maker.sizeToFit()
        }
        ammountTextFieldRightViewLabel.configureFrame { maker in
            maker.sizeToFit()
        }
        whereToGetDropDownButton.configureFrame { maker in
            maker.sizeToFit()
        }

        categoryDropDown.width = categoryTextField.bounds.width
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: categoryTextField.bounds.height)
        whereToGetDropDown.width = whereToGetTextField.bounds.width
        whereToGetDropDown.bottomOffset = CGPoint(x: 0, y: whereToGetTextField.bounds.height)

        addRecordButton.configureFrame { maker in
            maker.size(width: 220, height: 45).top(inset: height * 0.84).centerX()
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: addRecordButton.frame.maxY)

        guard let topInsetForActivityIndicator = navigationController?.navigationBar.bounds.height else {
            return
        }
        activityIndicatorView.configureFrame { maker in
            maker.centerX().centerY(offset: topInsetForActivityIndicator)
        }
    }

    private func collectContainer(viewHeight height: CGFloat) -> UIView {
        let views = [
            categoryLabel, categoryTextField, amountLabel, amountTextField,
            commentTextField, amountErrorLabel, whereToGetLabel, whereToGetTextField
        ]
        let container = views.container(in: scrollView) {
            categoryLabel.configureFrame { maker in
                maker.left().top().sizeToFit()
            }
            categoryTextField.configureFrame { maker in
                maker.size(width: 220, height: 28).top(to: categoryLabel.nui_bottom).centerX()
            }
            amountLabel.configureFrame { maker in
                maker.sizeToFit().left().top(to: categoryTextField.nui_bottom, inset: height * 0.03)
            }
            amountTextField.configureFrame { maker in
                maker.size(width: 220, height: 28).top(to: amountLabel.nui_bottom).centerX()
            }
            commentTextField.configureFrame { maker in
                maker.size(width: 220, height: 28)
                maker.top(to: amountTextField.nui_bottom, inset: height * 0.06).centerX()
            }
            amountErrorLabel.configureFrame { maker in
                maker.width(220).heightToFit()
                maker.top(to: commentTextField.nui_bottom, inset: height * 0.042).centerX()
            }
            whereToGetLabel.configureFrame { maker in
                maker.sizeToFit().left().top(to: commentTextField.nui_bottom, inset: height * 0.15)
            }
            whereToGetTextField.configureFrame { maker in
                maker.size(width: 220, height: 28).top(to: whereToGetLabel.nui_bottom).centerX()
            }
        }
        return container
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // I think this is bad (show to mentor)
        navigationController?.navigationBar.barTintColor = UIColor.sea

        NotificationCenter.default.removeObserver(self) // swiftlint:disable:this notification_center_detachment
    }

    // MARK: - Fetch data

    private func fetchData() {
        activityIndicatorView.startAnimating()
        dependencies.categoriesService.fetchCategories(parameters: FetchCategoriesParameters(), success: { categoriesDataResponse in
            self.activityIndicatorView.stopAnimating()
            self.categoriesDataResponse = categoriesDataResponse
            self.categoriesData = categoriesDataResponse.categories.compactMap { category -> String? in
                if category.kindID == 6 {
                    return nil
                }
                return category.name
            }
            self.categoryDropDown.dataSource = self.categoriesData
            if let firstCategoryName = self.categoriesData.first {
                self.categoryTextField.text = firstCategoryName
                self.categoryDropDown.selectRow(0)
            }
        }, failure: { error in
            self.activityIndicatorView.stopAnimating()
            if let generalRequestError = error as? GeneralRequestError {
                let alertController = UIAlertController(title: Bundle.main.appName,
                                                        message: generalRequestError.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                    let loginViewcontroller = LoginViewController(dependencies: Services)
                    self.navigationController?.setViewControllers([loginViewcontroller], animated: true)
                }))
                self.present(alertController, animated: true)
            }
        })
    }

    // MARK: - Showing keyboard

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        scrollView.delaysContentTouches = true
        tapRecognizer.isEnabled = true
        if let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let addRecordButtonFrame = scrollView.convert(whereToGetTextField.frame, from: whereToGetTextField.superview)
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

    @objc private func addRecordButtonPressed(_ sender: UIButton) {
        guard let categoriesDataResponse = self.categoriesDataResponse,
            let operationName = commentTextField.text,

            let selectCategoryName = categoryDropDown.selectedItem,
            let category = categoriesDataResponse[selectCategoryName],

            let amountString = amountTextField.text,
            let amount = Double(amountString) else {
                return
        }

        var categoryLoanID: UInt64?
        if !amountErrorLabel.isHidden,
            let selectWereToGetName = categoryDropDown.selectedItem,
            let categoryLoan = categoriesDataResponse[selectWereToGetName] {
            categoryLoanID = categoryLoan.id
        }

        let parameters = AddOperationParameters(operationName: operationName,
                                                 categoryID: category.id,
                                                 categoryLoanID: categoryLoanID,
                                                 amount: amount)

        activityIndicatorView.startAnimating()
        addRecordButton.isEnabled = false
        dependencies.operationsService.addOperation(parameters: parameters, success: { message in
            self.activityIndicatorView.stopAnimating()
            self.addRecordButton.isEnabled = true
            self.dismissViewController()
        }, failure: { error in
            self.activityIndicatorView.stopAnimating()
            self.addRecordButton.isEnabled = true
            if let generalRequestError = error as? GeneralRequestError {
                self.presentAlert(message: generalRequestError.localizedDescription, handler: { _ in
                    let loginViewcontroller = LoginViewController(dependencies: Services)
                    self.navigationController?.setViewControllers([loginViewcontroller], animated: true)
                })
            }
        })
    }

    private func dismissViewController() {
        if let homeViewController = delegate {
            homeViewController.wasChanged()
        }
        dismiss(animated: true)
    }

    @objc private func dropDownButtonPressed(_ sender: UIButton) {
        if sender === caregoryDropDownButton {
            categoryDropDown.show()
        } else {
            whereToGetDropDown.show()
        }
    }

    // MARK: - Validate user input

    private func validateInput() {
        guard let amountString = amountTextField.text else {
            return
        }
        amountErrorLabel.isHidden = validateCategoryBalance(amountString: amountString)
        if Double(amountString) != 0.0, amountString.isValidAmount, amountErrorLabel.isHidden {
            addRecordButton.isEnabled = true
        } else {
            addRecordButton.isEnabled = false
        }
    }

    private func validateCategoryBalance(amountString: String) -> Bool {
        if let categoriesDataResponse = categoriesDataResponse,
            let selectCategoryName = categoryDropDown.selectedItem,
            let selectCategory = categoriesDataResponse[selectCategoryName],
            let amount = Double(amountString) {

            if amount > selectCategory.amount {
                whereToGetLabel.isHidden = false
                whereToGetTextField.isHidden = false

                if let selectWhereToGetName = whereToGetDropDown.selectedItem,
                    let selectWhereToGet = categoriesDataResponse[selectWhereToGetName] {
                    if amount > selectCategory.amount + selectWhereToGet.amount {
                        return false
                    } else {
                        return true
                    }
                }
                return false
            } else {
                whereToGetLabel.isHidden = true
                whereToGetTextField.isHidden = true
            }
        }
        return true
    }

    // MARK: - TextField controls

    @objc private func textFieldDidChange(_ sender: UITextField) {
        validateInput()
    }
}

extension AddRecordViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === categoryTextField || textField === whereToGetTextField {
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
