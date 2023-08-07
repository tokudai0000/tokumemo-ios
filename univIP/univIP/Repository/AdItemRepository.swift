//
//  AdItemRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation

protocol AdItemRepositoryInterface {
    func fetchBizCards() -> [AdItem]
    func fetchBizCard(id: String) -> AdItem?
    func addBizCard(_ adItem: AdItem)
    func updateBizCard(_ adItem: AdItem) -> Bool
}

/// クラスプロパティで保持するクラス
final class AdItemOnMemoryRepository: AdItemRepositoryInterface {
    static var shared = AdItemOnMemoryRepository()

    private var adItems: [AdItem]

    init() {
        adItems = []
    }

    func fetchBizCards() -> [AdItem] {
        return Self.shared.adItems
    }

    func fetchBizCard(id: String) -> AdItem? {
        return Self.shared.adItems.first(where: { $0.id == id })
    }

    func addBizCard(_ adItem: AdItem) {
        return Self.shared.adItems.append(adItem)
    }

    func updateBizCard(_ adItem: AdItem) -> Bool {
        guard let index = Self.shared.adItems.firstIndex(where: { $0.id == adItem.id }) else {
            return false
        }

        Self.shared.adItems[index] = adItem
        return true
    }
}
