//
//  Services.swift
//  ZenBudget
//
//  Created by Александр on 21.02.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

typealias HasServices =
    HasAuthService &
    HasProfileService &
    HasSessionService &
    HasKeychainService &
    HasErrorHandlingService &
    HasSummaryDataService &
    HasColorService &
    HasCategoriesService &
    HasKindsService &
    HasOperationsService

var Services: MainServices { //swiftlint:disable:this identifier_name
    return MainServices()
}

final class MainServices: HasServices {

    lazy var keychainService: KeychainServiceProtocol = KeychainService()

    lazy var sessionService: SessionServiceProtocol = SessionService.shared(keychainService: keychainService)

    lazy var errorHandlingService: ErrorHandlingServiceProtocol = ErrorHandlingService()

    lazy var authService: AuthServiceProtocol = AuthService(sessionService: sessionService,
                                                            errorHandlingService: errorHandlingService)

    lazy var profileService: ProfileServiceProtocol = ProfileService(sessionService: sessionService,
                                                                     errorHandlingService: errorHandlingService)

    lazy var summaryDataService: SummaryDataServiceProtocol = SummaryDataService(sessionService: sessionService,
                                                                                 errorHandlingService: errorHandlingService)

    lazy var colorService: ColorServiceProtocol = ColorService()

    lazy var categoriesService: CategoriesServiceProtocol = CategoriesService.shared(sessionService: sessionService,
                                                                                     errorHandlingService: errorHandlingService)

    lazy var kindsService: KindsServiceProtocol = KindsService.shared(sessionService: sessionService,
                                                                      errorHandlingService: errorHandlingService)

    lazy var operationsService: OperationsServiceProtocol = OperationsService(sessionService: sessionService,
                                                                              errorHandlingService: errorHandlingService)
}
