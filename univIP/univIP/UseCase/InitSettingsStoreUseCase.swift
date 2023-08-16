//
//  InitSettingsStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation

protocol InitSettingsStoreUseCaseInterface {
    func fetchNumberOfUsers() -> String
    func setNumberOfUsers(_ items: String)

    func fetchAcceptedTermVersion() -> String
    func setAcceptedTermVersion(_ items: String)

    func fetchTermText() -> String
    func setTermText(_ items: String)
}

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

    func setNumberOfUsers(_ items: String) {
        initSettingsRepository.setNumberOfUsers(items)
    }

    func fetchAcceptedTermVersion() -> String {
        return initSettingsRepository.fetchAcceptedTermVersion()
    }

    func setAcceptedTermVersion(_ items: String) {
        initSettingsRepository.setAcceptedTermVersion(items)
    }

    func fetchTermText() -> String {
        return initSettingsRepository.fetchTermText()
    }

    func setTermText(_ items: String) {
        initSettingsRepository.setTermText(items)
    }
}
