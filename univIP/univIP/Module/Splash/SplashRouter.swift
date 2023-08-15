//
//  SplashRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import UIKit

enum SplashNavigationDestination {
    case agree
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
            dependency: .init(router: self)
        )
    }

    func navigate(_ destination: SplashNavigationDestination) {
        switch destination {
        case .agree:
            present(AgreementRouter())
        case .main:
            present(MainRouter())
        }
    }
}
