//
//  InitSettingsStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation
import UIKit

protocol InitSettingsStoreUseCaseInterface {
    func fetchNumberOfUsers() -> String
    func assignmentNumberOfUsers(_ items: String)

    func fetchAcceptedTermVersion() -> String
    func assignmentAcceptedTermVersion(_ items: String)

    func fetchTermText() -> String
    func assignmentTermText(_ items: String)
}

/// 広告アイテム関係をRepositoryと読み書きするUseCase
struct InitSettingsStoreUseCase: InitSettingsStoreUseCaseInterface {

    private let initSettingsRepository: InitSettingsRepositoryInterface

    init(
        initSettingsRepository: InitSettingsRepositoryInterface
    ) {
        self.initSettingsRepository = initSettingsRepository
    }

    func fetchNumberOfUsers() -> String {
        return initSettingsRepository.fetchNumberOfUsers()
    }

    func assignmentNumberOfUsers(_ items: String) {
        initSettingsRepository.assignmentNumberOfUsers(items)
    }

    func fetchAcceptedTermVersion() -> String {
        return initSettingsRepository.fetchAcceptedTermVersion()
    }

    func assignmentAcceptedTermVersion(_ items: String) {
        initSettingsRepository.assignmentAcceptedTermVersion(items)
    }

    func fetchTermText() -> String {
        return initSettingsRepository.fetchTermText()
    }

    func assignmentTermText(_ items: String) {
        initSettingsRepository.assignmentTermText(items)
    }
}
