//
//  NewsRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation
import Features

enum NewsNavigationDestination {
    case goWeb(URLRequest)
}

protocol NewsRouterInterface {
    func navigate(_ destination: NewsNavigationDestination)
}

final class NewsRouter: BaseRouter, NewsRouterInterface {
    init() {
        let viewController = NewsViewController()
        super.init(moduleViewController: viewController)
        viewController.viewModel = NewsViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              newsItemsRSS: NewsItemsRSS()
                             )
        )
    }

    func navigate(_ destination: NewsNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        }
    }
}
