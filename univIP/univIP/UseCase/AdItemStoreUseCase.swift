//
//  AdItemStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation
import UIKit

protocol AdItemStoreUseCaseInterface {
    func fetchPrItems() -> [AdItem]
    func fetchUnivItems() -> [AdItem]
    func assignmentPrItems(_ items: [AdItem])
    func assignmentUnivItems(_ items: [AdItem])
}

/// 広告アイテム関係をRepositoryと読み書きするUseCase
struct AdItemStoreUseCase: AdItemStoreUseCaseInterface {
    private let prItemRepository: AdItemRepositoryInterface
    private let univItemRepository: AdItemRepositoryInterface

    init(
        prItemRepository: AdItemRepositoryInterface,
        univItemRepository: AdItemRepositoryInterface
    ) {
        self.prItemRepository = prItemRepository
        self.univItemRepository = univItemRepository
    }

    func fetchPrItems() -> [AdItem] {
        return prItemRepository.fetchPrItems()
    }
    func fetchUnivItems() -> [AdItem] {
        return univItemRepository.fetchUnivItems()
    }

    func assignmentPrItems(_ items: [AdItem]) {
        prItemRepository.assignmentPrItems(items)
    }
    func assignmentUnivItems(_ items: [AdItem]) {
        univItemRepository.assignmentUnivItems(items)
    }
}
