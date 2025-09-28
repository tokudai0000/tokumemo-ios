//
//  AcceptedTermVersionRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation

protocol AcceptedTermVersionRepositoryInterface {
    func fetchAcceptedTermVersion() -> String
    func setAcceptedTermVersion(_ items: String)
}

final class AcceptedTermVersionOnUserDefaultsRepository: AcceptedTermVersionRepositoryInterface {

    private var acceptedTermVersion: String

    init() {
        acceptedTermVersion = ""
    }

    private var userDefaults = UserDefaults.standard
    private let KEY_agreementVersion = "KEY_agreementVersion"
    
    func fetchAcceptedTermVersion() -> String {
        return userDefaults.string(forKey: KEY_agreementVersion) ?? ""
    }

    func setAcceptedTermVersion(_ items: String) {
        userDefaults.set(items ,forKey: KEY_agreementVersion)
    }
}
