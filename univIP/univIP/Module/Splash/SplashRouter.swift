//
//  SplashRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation
import API

enum SplashNavigationDestination {
    case agree
    case main
}

protocol SplashRouterInterface {
    func navigate(_ destination: SplashNavigationDestination)
}

final class SplashRouter: BaseRouter, SplashRouterInterface {
    init() {
        let viewController = SplashViewController()
        super.init(moduleViewController: viewController)
        viewController.viewModel = SplashViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              currentTermVersionAPI: CurrentTermVersionAPI(),
                              univAuthStoreUseCase: UnivAuthStoreUseCase(
                                univAuthRepository: UnivAuthOnKeyChainRepository()
                              ),
                              acceptedTermVersionStoreUseCase: AcceptedTermVersionStoreUseCase(
                                acceptedTermVersionRepository: AcceptedTermVersionOnUserDefaultsRepository()
                              )
                             )
        )
    }
    
    func navigate(_ destination: SplashNavigationDestination) {
        let rootViewController = moduleViewController.parent as? RootViewController
        switch destination {
        case .agree:
            rootViewController?.switchToAgreement()
        case .main:
            rootViewController?.switchToMain()
        }
    }
}
