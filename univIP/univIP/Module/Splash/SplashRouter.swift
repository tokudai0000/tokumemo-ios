//
//  SplashRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation
import Repository

enum SplashNavigationDestination {
    case agree(String)
    case main
}

protocol SplashRouterInterface {
    func navigate(_ destination: SplashNavigationDestination)
}

final class SplashRouter: BaseRouter, SplashRouterInterface {
    init() {
        let viewController = R.storyboard.splash.splashViewController()!
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
        case .agree(let currentAgreementVersion):
            rootViewController?.switchToAgreement(currentTermVersion: currentAgreementVersion)
        case .main:
            rootViewController?.switchToMain()
        }
    }
}
