//
//  SettingsViewController.swift
//  ZenBudget
//
//  Created by Александр on 9.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties

    typealias Dependencies = HasAuthService & HasCategoriesService & HasProfileService & HasSessionService & HasKindsService
    private let dependencies: Dependencies

    private var categoriesDataResponse: CategoriesDataResponse?
    private var lastSelectedCategory: Category?

    weak var delegate: ChildViewControllerDelegate?

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "НАСТРОЙКИ", attributes: StringAttributes.headerTextAttributes)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()

    private lazy var settingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteSmoke
        collectionView.register(SettingsCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: NSStringFromClass(SettingsCollectionViewHeader.self))
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CategoryCollectionViewCell.self))
        collectionView.register(AddCategoryCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AddCategoryCollectionViewCell.self))
        collectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AccountCollectionViewCell.self))
        return collectionView
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
        navigationItem.titleView = titleLabel

        view.addSubview(settingsCollectionView)

        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsCollectionView.configureFrame { maker in
            maker.edges(insets: .zero)
        }
    }

    deinit {
        print("\(self) \(#function)")
        if let homeViewController = delegate {
            homeViewController.wasChanged()
        }
    }

    // MARK: - Fetch data

    private func fetchData(with hud: ProgressHUD? = nil, needsDisplaySuccess: Bool = false) {
        let hud = hud ?? ProgressHUD.show(animated: true)
        dependencies.categoriesService.fetchCategories(parameters: FetchCategoriesParameters(),
                                                            success: { categoriesDataResponse in
            self.categoriesDataResponse = categoriesDataResponse
            self.settingsCollectionView.reloadData()
            hud?.hide(animated: true)
            if needsDisplaySuccess {
                ProgressHUD.showSuccess()
            }
        }, failure: { error in

            hud?.hide(animated: true)
            if let generalRequestError = error as? GeneralRequestError {
                let alertController = UIAlertController(title: Bundle.main.appName,
                                                        message: generalRequestError.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                    self.popToLoginViewController()
                }))
                self.present(alertController, animated: true)
            }
        })
    }

    private func popToLoginViewController() {
        let loginViewcontroller = LoginViewController(dependencies: Services)
        navigationController?.setViewControllers([loginViewcontroller], animated: true)
    }

    // MARK: - Buttons controls

    @objc private func addCategoryButtonPressed(_ sender: UIButton) {
        presentAddOrEditCategoryViewController(toAddCategory: true)
    }

    @objc private func changePasswordButtonPressed(_ sender: UIButton) {
        let changePasswordNavigationController = NavigationController(rootViewController: ChangePasswordViewController(dependencies: Services))
        navigationController?.present(changePasswordNavigationController, animated: true, completion: {})
    }

    @objc private func exitAccountButtonPressed(_ sender: UIButton) {
        dependencies.authService.logout()
        let loginViewcontroller = LoginViewController(dependencies: Services)
        navigationController?.setViewControllers([loginViewcontroller], animated: true)
    }

    @objc private func editCategoryButtonPressed() {
        presentAddOrEditCategoryViewController(toAddCategory: false)
    }

    @objc private func deleteCategoryButtonPressed() {
        guard let category = lastSelectedCategory else {
            return
        }
        let hud = ProgressHUD.show(animated: true)
        dependencies.categoriesService.deleteCategory(categoryID: category.id, success: { message in
            self.fetchData(with: hud)
        }, failure: { error in
            hud?.hide(animated: true)
            if let generalRequestError = error as? GeneralRequestError {
                let alertController = UIAlertController(title: Bundle.main.appName,
                                                        message: generalRequestError.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
                    self.popToLoginViewController()
                }))
                self.present(alertController, animated: true)
            }
        })
    }

    private func presentAddOrEditCategoryViewController(toAddCategory: Bool) {
        let addOrEditCategoryViewController = AddOrEditCategoryViewController(dependencies: Services, isAddCategory: toAddCategory)
        addOrEditCategoryViewController.delegate = self
        if !toAddCategory {
            addOrEditCategoryViewController.editableCategory = lastSelectedCategory
        }
        let categoryNavigationController = NavigationController(rootViewController: addOrEditCategoryViewController)
        navigationController?.present(categoryNavigationController, animated: true, completion: {})
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if categoriesDataResponse == nil {
            return 0
        }
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categoriesDataResponse = categoriesDataResponse else {
            return 0
        }
        if section == 0 {
            return categoriesDataResponse.categories.count + 1
        } else {
            return 1
        }
    }

    //swiftlint:disable force_cast
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoriesDataResponse = categoriesDataResponse else {
            fatalError("Unable to dequeue reusable cell for indexPath: \((indexPath.section, indexPath.item))")
        }
        if indexPath.section == 0 {
            if indexPath.row < categoriesDataResponse.categories.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CategoryCollectionViewCell.self),
                    for: indexPath) as! CategoryCollectionViewCell

                configureCategoryCollectionViewCell(categoriesDataResponse: categoriesDataResponse, cell: cell, indexPath: indexPath)

                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                    NSStringFromClass(AddCategoryCollectionViewCell.self),
                    for: indexPath) as! AddCategoryCollectionViewCell

                cell.addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)

                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AccountCollectionViewCell.self),
                for: indexPath) as! AccountCollectionViewCell
            if let user = dependencies.sessionService.session?.user {
                cell.headerLabel.text = user.email
            }
            cell.changePasswordButton.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
            cell.exitAccountButton.addTarget(self, action: #selector(exitAccountButtonPressed), for: .touchUpInside)

            return cell
        }
    }
    //swiftlint:enable force_cast

    private func configureCategoryCollectionViewCell(categoriesDataResponse: CategoriesDataResponse,
                                                     cell: CategoryCollectionViewCell,
                                                     indexPath: IndexPath) {
        let category = categoriesDataResponse.categories[indexPath.row]
        cell.categoryNameLabel.text = category.name

        let formattedCost = numberFormatter.string(from: NSNumber(value: category.amount))!
        let costAttributedString = NSMutableAttributedString(string: formattedCost, attributes: StringAttributes.costAttributes)
        let currencyAttributedString = NSAttributedString(string: " р./мес", attributes: StringAttributes.currencyAttributesWithAlpha)
        costAttributedString.append(currencyAttributedString)
        cell.amountLabel.attributedText = costAttributedString

        if let kindsDataResponse = dependencies.kindsService.kindsDataResponse,
            let categoryKind = kindsDataResponse[category.kindID] {
            cell.typeLabel.text = categoryKind.name
        }
        if let extra = category.extra, let remainingAmount = extra.remainingAmount {
            cell.descriptionLabel.text = "еще доступно \(Int(remainingAmount)) р."
            cell.lineScaleView.isHidden = true
        } else if let extra = category.extra, let accumulated = extra.sum, let goal = extra.goal {
            cell.lineScaleView.isHidden = false
            let percentage = CGFloat(accumulated / goal)
            cell.lineScaleView.percentage = percentage
            let formattedPercent = NSString(format: "%.1f", percentage * 100)
            cell.descriptionLabel.text = "накоплено \(formattedPercent)% из \(goal)"
        } else {
            cell.lineScaleView.isHidden = true
            cell.descriptionLabel.text = nil
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: NSStringFromClass(SettingsCollectionViewHeader.self),
                                     for: indexPath) as? SettingsCollectionViewHeader {
            if indexPath.section == 0 {
                view.titleLabel.text = "План расходов и доходов"
            } else {
                view.titleLabel.text = "Аккаунт"
            }
            return view
        }
        fatalError("Unable to dequeue reusable view for indexPath: \((indexPath.section, indexPath.item))")
    }

    // MARK: - Selecting cells

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0,
            let categoriesDataResponse = categoriesDataResponse,
            indexPath.row < categoriesDataResponse.categories.count,
            let kindsDataResponse = dependencies.kindsService.kindsDataResponse else {
                return
        }
        var actions: [AlertAction] = []

        let lastSelectedCategory = categoriesDataResponse.categories[indexPath.row]
        let lastSelectedCategoryKind = kindsDataResponse.kinds.first { kind -> Bool in
            kind.id == lastSelectedCategory.kindID
        }
        lastSelectedCategory.kind = lastSelectedCategoryKind
        self.lastSelectedCategory = lastSelectedCategory

        if let lastSelectedCategoryKind = lastSelectedCategoryKind,
            lastSelectedCategoryKind.isCategoryEditable {
            actions.append(AlertAction(title: "Редактировать", handler: editCategoryButtonPressed))
        }
        if let lastSelectedCategoryKind = lastSelectedCategoryKind,
            lastSelectedCategoryKind.isCategoryDeletable {
            actions.append(AlertAction(title: "Удалить", handler: deleteCategoryButtonPressed))
        }
        if !actions.isEmpty {
            presentActionSheetViewController(actions: actions)
        }
    }

    private func presentActionSheetViewController(actions: [AlertAction]) {
        let alertController = ActionSheetViewController(actions: actions)
        present(alertController, animated: false)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SettingsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.section == 0 else {
            return CGSize(width: collectionView.bounds.width, height: 180)
        }
        if let categories = self.categoriesDataResponse?.categories,
            indexPath.row < categories.count {
            if categories[indexPath.row].extra != nil {
                return CGSize(width: collectionView.bounds.width, height: 76)
            }
            return CGSize(width: collectionView.bounds.width, height: 66)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 77)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
}

extension SettingsViewController: ChildViewControllerDelegate {

    func wasChanged() {
        fetchData(needsDisplaySuccess: true)
    }
}
