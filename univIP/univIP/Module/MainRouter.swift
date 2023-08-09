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
        let viewController = MainViewController()
        super.init(moduleViewController: viewController)
    }

    func navigate(_ destination: MainNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        }
    }
}
