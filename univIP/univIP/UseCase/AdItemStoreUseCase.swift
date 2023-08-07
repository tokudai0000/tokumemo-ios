//
//  AdItemStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation
import UIKit

protocol AdItemStoreUseCaseInterface {
    func fetchBizCards() -> [AdItem]
    func fetchBizCard(id: String) -> AdItem?
    func addBizCard(_ bizCard: AdItem)
    func updateBizCard(_ bizCard: AdItem) -> Bool
//    func fetchImage(id: String) -> UIImage?
//    func addImage(id: String, image: UIImage)
}

/// 名刺情報をRepositoryと読み書きするUseCase
struct AdItemStoreUseCase: AdItemStoreUseCaseInterface {
    private let adItemRepository: AdItemRepositoryInterface
//    private let bizCardImageRepository: AdItemRepositoryInterface

    init(
        adItemRepository: AdItemRepositoryInterface
//        bizCardImageRepository: AdItemRepositoryInterface
    ) {
        self.adItemRepository = adItemRepository
//        self.bizCardImageRepository = bizCardImageRepository
    }

    func fetchBizCards() -> [AdItem] {
        return adItemRepository.fetchBizCards()
    }

    func fetchBizCard(id: String) -> AdItem? {
        return adItemRepository.fetchBizCard(id: id)
    }

    func addBizCard(_ bizCard: AdItem) {
        adItemRepository.addBizCard(bizCard)
    }

    func updateBizCard(_ bizCard: AdItem) -> Bool {
        return adItemRepository.updateBizCard(bizCard)
    }

//    func fetchImage(id: String) -> UIImage? {
//        return bizCardImageRepository.fetchImage(id: id)
//    }
//
//    func addImage(id: String, image: UIImage) {
//        bizCardImageRepository.addImage(id: id, image: image)
//    }
}
