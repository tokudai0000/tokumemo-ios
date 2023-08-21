//
//  SplashRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import UIKit

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
        switch destination {
        case .agree(let current):
            if let rootVC = moduleViewController.parent as? RootViewController {
                rootVC.switchToAgreement(currentTermVersion: current)
            }
        case .main:
            present(MainRouter())
        }
    }
}
