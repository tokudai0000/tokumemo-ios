//
//  NewsItemRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation

protocol NewsItemRepositoryInterface {
    func fetchNewsItems() -> [NewsItemModel]
    func assignmentNewsItems(_ items: [NewsItemModel])
}

/// クラスプロパティで保持するクラス
final class NewsItemOnMemoryRepository: NewsItemRepositoryInterface {
    static var shared = NewsItemOnMemoryRepository()

    private var newsItems: [NewsItemModel]

    init() {
        newsItems = []
    }

    func fetchNewsItems() -> [NewsItemModel] {
        return Self.shared.newsItems
    }

    func assignmentNewsItems(_ items: [NewsItemModel]) {
        return Self.shared.newsItems = items
    }
}
