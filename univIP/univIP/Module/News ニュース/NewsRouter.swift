//
//  NewsRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation
import UIKit

protocol NewsRouterInterface {
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
                              newsItemStoreUseCase: NewsItemStoreUseCase(newsItemRepository: NewsItemOnMemoryRepository())
        ))
    }
}
