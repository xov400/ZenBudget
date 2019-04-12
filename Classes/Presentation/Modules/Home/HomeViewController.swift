//
//  HomeViewController.swift
//  ZenBudget
//
//  Created by Александр on 22.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import UIKit
import CollectionViewTools
import SwiftDate

final class HomeViewController: UIViewController {

    // MARK: - Properties

    typealias Dependencies =
        HasSummaryDataService &
        HasKindsService &
        HasOperationsService &
        HasCategoriesService

    private let dependencies: Dependencies

    private lazy var collectionViewManager: CollectionViewManager = {
        let manager = CollectionViewManager(collectionView: collectionView)
        manager.scrollDelegate = self
        return manager
    }()

    private(set) var summaryDataResponse: SummaryDataResponse?
    private var operationsDataResponse: OperationsDataResponse?
    var sorteredOperations: [Operation] = []
    private(set) var isLastPage = false

    private let rightNow = Date()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = UIColor.gray
        return indicator
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

    private lazy var titleView = UIView()

    private lazy var settingsButton = UIBarButtonItem(image: UIImage(named: "settings"),
                                     style: UIBarButtonItem.Style.plain,
                                     target: self, action: #selector(settingsButtonPressed))

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.sea
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private lazy var addExpenceItemButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add record button"), for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        button.setTitleShadowColor(.black, for: .normal)
        return button
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

        view.backgroundColor = UIColor.sea
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setRightBarButton(settingsButton, animated: true)
        navigationItem.titleView = titleView
        view.addSubview(collectionView)
        view.addSubview(addExpenceItemButton)
        view.addSubview(activityIndicatorView)

        fetchData(initially: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let container = [logoImageView, zenBudgetLabel].container(in: titleView) {
            logoImageView.configureFrame { maker in
                maker.top()
                maker.size(width: 30, height: 30)
            }
            zenBudgetLabel.configureFrame(installerBlock: { maker in
                maker.sizeToFit()
                maker.left(to: logoImageView.nui_right, inset: 8).top(inset: 5)
            })
        }
        container.configureFrame { maker in
            maker.center()
        }
        collectionView.configureFrame { maker in
            maker.equal(to: view)
        }
        addExpenceItemButton.configureFrame { maker in
            maker.sizeToFit()
            maker.centerX().bottom(inset: view.bounds.height * 0.001)
        }
        guard let topInsetForActivityIndicator = navigationController?.navigationBar.bounds.height else {
            return
        }
        activityIndicatorView.configureFrame { maker in
            maker.centerX().centerY(offset: topInsetForActivityIndicator)
        }
    }

    // MARK: - Fetch data

    private func fetchData(initially: Bool) {
        activityIndicatorView.startAnimating()
        DispatchQueue.global(qos: .background).async {
            let dispatchGroup = DispatchGroup()

            if initially {
                self.fetchCategories(dispatchGroup: dispatchGroup)
                self.fetchKinds(dispatchGroup: dispatchGroup)
            }
            self.fetchSummaryData(dispatchGroup: dispatchGroup)
            self.fetchOperations(initially: initially, dispatchGroup: dispatchGroup)

            dispatchGroup.wait()

            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.updateCollectionView()
            }
        }
    }

    private func fetchCategories(dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        dependencies.categoriesService.fetchCategories(parameters: FetchCategoriesParameters(), success: { _ in
            dispatchGroup?.leave()
        }, failure: { error in
            if case GeneralRequestError.unauthorized = error {
                self.pushErrorAlert(message: error.localizedDescription, handler: { _ in
                    let loginViewcontroller = LoginViewController(dependencies: Services)
                    self.navigationController?.setViewControllers([loginViewcontroller], animated: true)
                })
            } else if let generalRequestError = error as? GeneralRequestError {
                self.pushErrorAlert(message: generalRequestError.localizedDescription)
            }
            dispatchGroup?.leave()
        })
    }

    private func fetchKinds(dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        dependencies.kindsService.fetchKindsService(success: { _ in
            dispatchGroup?.leave()
        }, failure: { error in
            if case GeneralRequestError.unauthorized = error {
                self.pushErrorAlert(message: error.localizedDescription, handler: { _ in
                    let loginViewcontroller = LoginViewController(dependencies: Services)
                    self.navigationController?.setViewControllers([loginViewcontroller], animated: true)
                })
            } else if let generalRequestError = error as? GeneralRequestError {
                self.pushErrorAlert(message: generalRequestError.localizedDescription)
            }
            dispatchGroup?.leave()
        })
    }

    private func fetchSummaryData(dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        self.dependencies.summaryDataService.fetchSummaryData(success: { summaryDataResponse in
            self.summaryDataResponse = summaryDataResponse
            dispatchGroup?.leave()
        }, failure: { error in
            if case GeneralRequestError.unauthorized = error {
                self.pushErrorAlert(message: error.localizedDescription, handler: { _ in
                    let loginViewcontroller = LoginViewController(dependencies: Services)
                    self.navigationController?.setViewControllers([loginViewcontroller], animated: true)
                })
            } else if let generalRequestError = error as? GeneralRequestError {
                self.pushErrorAlert(message: generalRequestError.localizedDescription)
            }
            dispatchGroup?.leave()
        })
    }

    private func fetchOperations(initially: Bool, dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        self.dependencies.operationsService.fetchOperations(initially: initially,
                                                            withTrashedCategories: true,
                                                            success: { (operationsDataResponse, isLastPage) in
            self.operationsDataResponse = operationsDataResponse
            self.sorteredOperations = operationsDataResponse.operations.sorted { $0.createdAt > $1.createdAt }
            self.isLastPage = isLastPage
            dispatchGroup?.leave()
        }, failure: { error in
            if case GeneralRequestError.unauthorized = error {
                self.pushErrorAlert(message: error.localizedDescription, handler: { _ in
                    let loginViewcontroller = LoginViewController(dependencies: Services)
                    self.navigationController?.setViewControllers([loginViewcontroller], animated: true)
                })
            } else if let generalRequestError = error as? GeneralRequestError {
                self.pushErrorAlert(message: generalRequestError.localizedDescription)
            }
            dispatchGroup?.leave()
        })
    }

    private func pushErrorAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: Bundle.main.appName,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .default, handler: handler))
        present(alertController, animated: true)
    }

    // MARK: - Factory Methods

//    private func appendExpenseHistorySectionItems(from operationsDataResponse: OperationsDataResponse) {
//
//        let sortedColoredOperations = createSortedColoredOperations(operationsDataResponse: operationsDataResponse)
//
//        guard let firstOperationFromNew = sortedColoredOperations.first,
//            let oldResponse = self.summaryDataResponse,
//            let lastOperationFromOld = oldResponse.operations.last else {
//                return
//        }
//        let operationDate = firstOperationFromNew.operation.createdAt.dateAtStartOf(.day)
//        if  operationDate == lastOperationFromOld.createdAt.dateAtStartOf(.day) {
//            let operationCellItems = sortedColoredOperations.reduce(into: [OperationCollectionViewCellItem]()) { result, coloredOperation in
//                if coloredOperation.operation.createdAt.isInside(date: operationDate, granularity: .day) {
//                    result.append(OperationCollectionViewCellItem(operation: coloredOperation))
//                }
//            }
//
//            collectionViewManager.append(operationCellItems, to: collectionViewManager.sectionItems.last!)
//        } else {
//            collectionViewManager.sectionItems.insert(contentsOf: expensesHistorySectionItems(from: sortedColoredOperations),
//                                                  at: collectionViewManager.sectionItems.count - 1)
//        }
//
//        if isLastPage {
//            collectionViewManager.remove(sectionItemsAt: [collectionViewManager.sectionItems.count - 1])
//            collectionView.contentInset.bottom = 0
//        }
//    }

    private func updateCollectionView() {
        guard let summaryDataResponse = summaryDataResponse else {
            return
        }
        let coloredFunds = dependencies.categoriesService.coloredCategories.compactMap { category -> ColoredCategory? in
            if category.category.kindID == 4 {
                return category
            }
            return nil
        }
        let sorteredOperations = self.sorteredOperations
        let amount = sorteredOperations.reduce(0, { (result, operation) -> Double in
            if operation.createdAt.month == rightNow.month {
                return result + operation.amount
            }
            return result
        })

        var sectionItems: [CollectionViewSectionItem] = [
            dailyExpensesSectionItem(withResidue: summaryDataResponse.dailyExpenses.amount,
                                     percent: summaryDataResponse.dailyExpenses.abnormalPercent),
            monthFundsSectionItem(with: coloredFunds),
            expensesAmountSectionItem(month: rightNow.monthName(.default), amount: amount)
        ]

        sectionItems.append(contentsOf:
            expensesHistorySectionItems(from: sorteredOperations,
                                        coloredCategories: dependencies.categoriesService.coloredCategories))

        if !isLastPage {
            collectionView.contentInset.bottom = 60
            sectionItems.append(loaderCollectionViewCellItem())
        } else {
            collectionView.contentInset.bottom = 0
        }

        collectionViewManager.sectionItems = sectionItems
    }

    private func dailyExpensesSectionItem(withResidue residue: Double, percent: Double) -> CollectionViewSectionItem {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: [DailyExpensesCollectionViewCellItem(residue: residue, percent: percent)])
        sectionItem.insets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        return sectionItem
    }

    private func monthFundsSectionItem(with coloredFunds: [ColoredCategory]) -> CollectionViewSectionItem {
        let cellItems = [MonthFundsCollectionViewCellItem(coloredFunds: coloredFunds)]
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: cellItems)
        sectionItem.insets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        return sectionItem
    }

    private func expensesAmountSectionItem(month: String, amount: Double) -> CollectionViewSectionItem {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: [
            ExpenseHistoryCollectionViewCellItem(month: month, fundAmount: amount)
            ])
        sectionItem.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return sectionItem
    }

    private func expensesHistorySectionItems(from sortedOperations: [Operation],
                                             coloredCategories: [ColoredCategory]) -> [CollectionViewSectionItem] {
        var sectionItems: [CollectionViewSectionItem] = []

        guard let firstOperation = sortedOperations.first else {
            return sectionItems
        }
        var baseDate = firstOperation.createdAt.dateAtStartOf(.day)
        var operationsForSectionItem: [Operation] = []
        var iteration = 0
        sortedOperations.forEach { operation in
            iteration += 1

            if operation.createdAt.isInside(date: baseDate, granularity: .day) {
                operationsForSectionItem.append(operation)
                if iteration != sortedOperations.count {
                    return
                }
            }

            let operationCellItems = operationsForSectionItem.map { operation -> OperationCollectionViewCellItem in
                var color = UIColor.gray
                let firstColoredCategory = coloredCategories.first { coloredCategory -> Bool in
                    return operation.categoryID == coloredCategory.category.id
                }
                if let coloredCategory = firstColoredCategory {
                    color = coloredCategory.color
                }
                return OperationCollectionViewCellItem(operation: operation, color: color)
            }
            let reusableViewItem = DailyExpenseHeaderReusableViewItem(type: .header, text: dateFormatter.string(from: baseDate))
            let sectionItem = GeneralCollectionViewSectionItem(cellItems: operationCellItems, reusableViewItems: [reusableViewItem])
            sectionItem.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            sectionItem.minimumLineSpacing = 0
            sectionItems.append(sectionItem)

            baseDate = operation.createdAt.dateAtStartOf(.day)
            operationsForSectionItem.removeAll()
            operationsForSectionItem.append(operation)
        }
        return sectionItems
    }

    private func loaderCollectionViewCellItem() -> CollectionViewSectionItem {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: [LoaderCollectionViewCellItem()])
        sectionItem.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return sectionItem
    }

    // MARK: - Button controls

    @objc private func settingsButtonPressed(_ sender: UIButton) {
        let settingsViewController = SettingsViewController(dependencies: Services)
        settingsViewController.delegate = self
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    @objc private func addButtonPressed(_ sender: UIButton) {
        let addRecordViewController = AddRecordViewController(dependencies: Services)
        addRecordViewController.delegate = self

        let navigationController = NavigationController(rootViewController: addRecordViewController)
        self.navigationController?.present(navigationController, animated: true, completion: {})
    }
}

extension HomeViewController: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if velocity.y > 0, distance < collectionView.bounds.height / 2, !isLastPage {
            fetchOperations(initially: false)
        }
    }
}

extension HomeViewController: ChildViewControllerDelegate {

    func wasChanged() {
        fetchData(initially: true)
    }
}
