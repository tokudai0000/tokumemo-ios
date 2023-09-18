//
//  PrRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/10.
//

import Foundation
import Entity

enum PRNavigationDestination {
    case goWeb(URLRequest)
    case close
}

protocol PRRouterInterface {
    func navigate(_ destination: PRNavigationDestination)
}

final class PRRouter: BaseRouter, PRRouterInterface {
    init(prItem: AdItem) {
        let viewController = R.storyboard.pR.prViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = PRViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              prItem: prItem)
        )
    }

    func navigate(_ destination: PRNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        case .close:
            moduleViewController.dismiss(animated: true)
        }
    }
}
