//
//  AdItemStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation

protocol AdItemStoreUseCaseInterface {
    func fetchAdItems() -> AdItems
    func setAdItems(_ items: AdItems)
}

/// 広告アイテム関係をRepositoryと読み書きするUseCase
struct AdItemStoreUseCase: AdItemStoreUseCaseInterface {
    private let adItemRepository: AdItemRepositoryInterface

    init(
        adItemRepository: AdItemRepositoryInterface
    ) {
        self.adItemRepository = adItemRepository
    }

    func fetchAdItems() -> AdItems {
        return adItemRepository.fetchAdItems()
    }

    func setAdItems(_ items: AdItems) {
        adItemRepository.setAdItems(items)
    }
}
