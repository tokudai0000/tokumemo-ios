//
//  NewsItemRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation

protocol NewsItemRepositoryInterface {
    func fetchNewsItems() -> [NewsItem]
    func assignmentNewsItems(_ items: [NewsItem])
}

/// クラスプロパティで保持するクラス
final class NewsItemOnMemoryRepository: NewsItemRepositoryInterface {
    static var shared = NewsItemOnMemoryRepository()

    private var newsItems: [NewsItem]

    init() {
        newsItems = []
    }

    func fetchNewsItems() -> [NewsItem] {
        return Self.shared.newsItems
    }

    func assignmentNewsItems(_ items: [NewsItem]) {
        return Self.shared.newsItems = items
    }
}
