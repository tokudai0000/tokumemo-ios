//
//  InitSettingsRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation

protocol InitSettingsRepositoryInterface {
    func fetchNumberOfUsers() -> String
    func setNumberOfUsers(_ items: String)

    func fetchAcceptedTermVersion() -> String
    func setAcceptedTermVersion(_ items: String)

    func fetchTermText() -> String
    func setTermText(_ items: String)
}

final class InitSettingsOnMemoryRepository: InitSettingsRepositoryInterface {
    static var shared = InitSettingsOnMemoryRepository()

    private var numberOfUsers: String
    private var acceptedTermVersion: String
    private var termText: String

    init() {
        numberOfUsers = ""
        acceptedTermVersion = ""
        termText = ""
    }

    func fetchNumberOfUsers() -> String {
        return Self.shared.numberOfUsers
    }

    func setNumberOfUsers(_ items: String) {
        Self.shared.numberOfUsers = items
    }

    private var userDefaults = UserDefaults.standard
    private let KEY_agreementVersion = "KEY_agreementVersion"
    func fetchAcceptedTermVersion() -> String {
        return userDefaults.string(forKey: KEY_agreementVersion) ?? ""
    }

    func setAcceptedTermVersion(_ items: String) {
        userDefaults.set(items ,forKey: KEY_agreementVersion)
    }

    func fetchTermText() -> String {
        return Self.shared.termText
    }

    func setTermText(_ items: String) {
        Self.shared.termText = items
    }
}
