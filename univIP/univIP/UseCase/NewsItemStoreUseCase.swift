//
//  NewsItemStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation

protocol NewsItemStoreUseCaseInterface {
    func fetchNewsItems() -> [NewsItemModel]
    func setNewsItems(_ items: [NewsItemModel])
}

struct NewsItemStoreUseCase: NewsItemStoreUseCaseInterface {
    private let newsItemRepository: NewsItemRepositoryInterface

    init(
        newsItemRepository: NewsItemRepositoryInterface
    ) {
        self.newsItemRepository = newsItemRepository
    }

    func fetchNewsItems() -> [NewsItemModel] {
        return newsItemRepository.fetchNewsItems()
    }

    func setNewsItems(_ items: [NewsItemModel]) {
        newsItemRepository.setNewsItems(items)
    }
}
