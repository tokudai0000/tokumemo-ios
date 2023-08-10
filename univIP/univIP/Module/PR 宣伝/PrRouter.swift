//
//  PrRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/10.
//

import UIKit

enum PrNavigationDestination {
    case goWeb(URLRequest)
    case agree
}

protocol PrRouterInterface {
    func navigate(_ destination: PrNavigationDestination)
}

final class PrRouter: BaseRouter, PrRouterInterface {
    init(prItem: AdItem) {
        let viewController = R.storyboard.pR.prViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = PrViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              prItem: prItem)
        )
    }

    func navigate(_ destination: PrNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        case .agree:
            present(HomeRouter())
        }
    }
}
