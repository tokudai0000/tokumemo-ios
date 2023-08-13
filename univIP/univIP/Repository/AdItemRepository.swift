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
    func assignmentPrItems(_ items: [AdItem])
    func assignmentUnivItems(_ items: [AdItem])
}

/// クラスプロパティで保持するクラス
final class AdItemOnMemoryRepository: AdItemRepositoryInterface {
    static var shared = AdItemOnMemoryRepository()

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

    func assignmentPrItems(_ items: [AdItem]) {
        return Self.shared.prItems = items
    }
    func assignmentUnivItems(_ items: [AdItem]) {
        return Self.shared.univItems = items
    }
}
