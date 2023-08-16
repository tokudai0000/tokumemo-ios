//
//  NewsItemRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation

protocol NewsItemRepositoryInterface {
    func fetchNewsItems() -> [NewsItemModel]
    func setNewsItems(_ items: [NewsItemModel])
}

final class NewsItemOnMemoryRepository: NewsItemRepositoryInterface {
    static let shared = NewsItemOnMemoryRepository()

    private var newsItems: [NewsItemModel]

    init() {
        newsItems = []
    }

    func fetchNewsItems() -> [NewsItemModel] {
        Self.shared.newsItems
    }

    func setNewsItems(_ items: [NewsItemModel]) {
        Self.shared.newsItems = items
    }
}
