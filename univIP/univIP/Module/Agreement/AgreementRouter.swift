//
//  AgreementRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/04.
//

import Foundation
import API

enum AgreementNavigationDestination {
    case goWeb(URLRequest)
    case agreedUpon
}

protocol AgreementRouterInterface {
    func navigate(_ destination: AgreementNavigationDestination)
}

final class AgreementRouter: BaseRouter, AgreementRouterInterface {
    init() {
        let viewController = AgreementViewController()
        super.init(moduleViewController: viewController)
        viewController.viewModel = AgreementViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              termTextAPI: TermTextAPI(),
                              acceptedTermVersionStoreUseCase: AcceptedTermVersionStoreUseCase(
                                acceptedTermVersionRepository: AcceptedTermVersionOnUserDefaultsRepository()
                              )
                             )
        )
    }

    func navigate(_ destination: AgreementNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        case .agreedUpon:
            let rootViewController = moduleViewController.parent as? RootViewController
            rootViewController?.switchToMain()
        }
    }
}
