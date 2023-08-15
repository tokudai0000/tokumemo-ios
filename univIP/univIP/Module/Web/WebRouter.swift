//
//  WebRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/05.
//

import Foundation
import UIKit

enum WebNavigationDestination {
    case goWeb
    case agree
}

protocol WebRouterInterface {
    func navigate(_ destination: WebNavigationDestination)
}

final class WebRouter: BaseRouter, WebRouterInterface {
    init(loadUrl: URLRequest) {
        let viewController = R.storyboard.web.webViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = WebViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                             loadUrl: loadUrl,
                              passwordStoreUseCase: PasswordStoreUseCase(passwordRepository: PasswordOnKeyChainRepository()))
        )

    }

    func navigate(_ destination: WebNavigationDestination) {
        switch destination {
        case .goWeb:
            moduleViewController.navigationController?.popViewController(animated: true)
        case .agree:
            moduleViewController.dismiss(animated: true)
        }
    }
}
