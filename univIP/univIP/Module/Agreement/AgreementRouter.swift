//
//  AgreementRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/04.
//

import UIKit

enum AgreementNavigationDestination {
    case goWeb(URLRequest)
    case agree
}

protocol AgreementRouterInterface {
    func navigate(_ destination: AgreementNavigationDestination)
}

final class AgreementRouter: BaseRouter, AgreementRouterInterface {
    init(currentTermVersion: String) {
        let viewController = R.storyboard.agreement.agreemantViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = AgreementViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              currentTermVersion: currentTermVersion,
                              initSettingsStoreUseCase: InitSettingsStoreUseCase(initSettingsRepository: InitSettingsOnMemoryRepository()))
        )
    }

    func navigate(_ destination: AgreementNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        case .agree:
            present(HomeRouter())
        }
    }
}
