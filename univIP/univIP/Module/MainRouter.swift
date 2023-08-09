//
//  MainRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation
import UIKit

enum MainNavigationDestination {
    case goWeb(URLRequest)
}

protocol MainRouterInterface {
    func navigate(_ destination: MainNavigationDestination)
}

final class MainRouter: BaseRouter, MainRouterInterface {
    init() {
        let viewController = R.storyboard.agreement.agreemantViewController()!
        super.init(moduleViewController: viewController)
//        viewController.viewModel = AgreementViewModel(
//            input: .init(),
//            state: .init(),
//            dependency: .init(router: self)
//        )

    }

    func navigate(_ destination: MainNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        }
    }
}
