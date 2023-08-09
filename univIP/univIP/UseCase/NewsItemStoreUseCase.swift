//
//  NewsItemStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation
import UIKit

protocol NewsItemStoreUseCaseInterface {
    func fetchNewsItems() -> [NewsItem]
    func assignmentNewsItems(_ items: [NewsItem])
}

/// 広告アイテム関係をRepositoryと読み書きするUseCase
struct NewsItemStoreUseCase: NewsItemStoreUseCaseInterface {
    private let newsItemRepository: NewsItemRepositoryInterface

    init(
        newsItemRepository: NewsItemRepositoryInterface
    ) {
        self.newsItemRepository = newsItemRepository
    }

    func fetchNewsItems() -> [NewsItem] {
        return newsItemRepository.fetchNewsItems()
    }

    func assignmentNewsItems(_ items: [NewsItem]) {
        newsItemRepository.assignmentNewsItems(items)
    }
}
