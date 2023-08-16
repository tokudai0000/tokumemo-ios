//
//  AdItemStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation

protocol AdItemStoreUseCaseInterface {
    func fetchPrItems() -> [AdItem]
    func fetchUnivItems() -> [AdItem]
    func setPrItems(_ items: [AdItem])
    func setUnivItems(_ items: [AdItem])
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

    func setPrItems(_ items: [AdItem]) {
        prItemRepository.setPrItems(items)
    }
    func setUnivItems(_ items: [AdItem]) {
        univItemRepository.setUnivItems(items)
    }
}
