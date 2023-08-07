//
//  HomeRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation
import UIKit

enum HomeNavigationDestination {
    case goWeb(URLRequest)
    case detail(AdItem)
}

protocol HomeRouterInterface {
    func navigate(_ destination: HomeNavigationDestination)
}

final class HomeRouter: BaseRouter, HomeRouterInterface {
    init() {
        let viewController = R.storyboard.home.homeViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = HomeViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self)
        )

    }

    func navigate(_ destination: HomeNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        case .detail(let item):
            moduleViewController.dismiss(animated: true)
        }
    }
}
