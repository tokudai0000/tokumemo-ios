//
//  ClubListRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation
import UIKit

enum ClubListNavigationDestination {
    case goWeb(URLRequest)
}

protocol ClubListRouterInterface {
    func navigate(_ destination: ClubListNavigationDestination)
}

final class ClubListRouter: BaseRouter, ClubListRouterInterface {
    init() {
        let viewController = R.storyboard.clubList.clubListViewController()!
        super.init(moduleViewController: viewController)
//        viewController.viewModel = HomeViewModel(
//            input: .init(),
//            state: .init(),
//            dependency: .init(router: self)
//        )

    }

    func navigate(_ destination: ClubListNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        }
    }
}
