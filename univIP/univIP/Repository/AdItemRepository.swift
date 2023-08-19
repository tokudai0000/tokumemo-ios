//
//  AdItemOnMemoryRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation

protocol AdItemRepositoryInterface {
    func fetchAdItems() -> AdItems
    func setAdItems(_ items: AdItems)
}

final class AdItemOnMemoryRepository: AdItemRepositoryInterface {
    static let shared = AdItemOnMemoryRepository()

    // PrItemsとUnivItemsを保持
    private var adItems: AdItems

    init() {
        adItems = AdItems(prItems: [], univItems: [])
    }

    func fetchAdItems() -> AdItems {
        return Self.shared.adItems
    }

    func setAdItems(_ items: AdItems) {
        Self.shared.adItems = items
    }
}
