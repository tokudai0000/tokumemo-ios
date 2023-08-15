//
//  InitSettingsRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation

protocol InitSettingsRepositoryInterface {
    func fetchNumberOfUsers() -> String
    func assignmentNumberOfUsers(_ items: String)

    func fetchAcceptedTermVersion() -> String
    func assignmentAcceptedTermVersion(_ items: String)

    func fetchTermText() -> String
    func assignmentTermText(_ items: String)
}

/// クラスプロパティで保持するクラス
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
        Self.shared.numberOfUsers
    }

    func assignmentNumberOfUsers(_ items: String) {
        return Self.shared.numberOfUsers = items
    }

    private var userDefaults = UserDefaults.standard
    private let KEY_agreementVersion = "KEY_agreementVersion"
    func fetchAcceptedTermVersion() -> String {
        return userDefaults.string(forKey: KEY_agreementVersion) ?? ""
    }

    func assignmentAcceptedTermVersion(_ items: String) {
        userDefaults.set(items ,forKey: KEY_agreementVersion)
    }

    func fetchTermText() -> String {
        Self.shared.termText
    }

    func assignmentTermText(_ items: String) {
        return Self.shared.termText = items
    }
}
