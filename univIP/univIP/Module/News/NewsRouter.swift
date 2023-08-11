//
//  NewsRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation
import UIKit

enum NewsNavigationDestination {
    case goWeb(URLRequest)
}

protocol NewsRouterInterface {
    func navigate(_ destination: NewsNavigationDestination)
}

final class NewsRouter: BaseRouter, NewsRouterInterface {
    init() {
        let viewController = R.storyboard.news.newsViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = NewsViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              newsItemsRSS: NewsItemsRSS(),
                              newsItemStoreUseCase: NewsItemStoreUseCase(newsItemRepository: NewsItemOnMemoryRepository())))
    }

    func navigate(_ destination: NewsNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        }
    }
}
