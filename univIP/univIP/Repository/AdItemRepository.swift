//
//  AdItemOnMemoryRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation

protocol AdItemRepositoryInterface {
    func fetchPrItems() -> [AdItem]
    func fetchUnivItems() -> [AdItem]
    func setPrItems(_ items: [AdItem])
    func setUnivItems(_ items: [AdItem])
}

final class AdItemOnMemoryRepository: AdItemRepositoryInterface {
    static let shared = AdItemOnMemoryRepository()

    private var prItems: [AdItem]
    private var univItems: [AdItem]

    init() {
        prItems = []
        univItems = []
    }

    func fetchPrItems() -> [AdItem] {
        return Self.shared.prItems
    }
    func fetchUnivItems() -> [AdItem] {
        return Self.shared.univItems
    }

    func setPrItems(_ items: [AdItem]) {
        Self.shared.prItems = items
    }
    func setUnivItems(_ items: [AdItem]) {
        Self.shared.univItems = items
    }
}
