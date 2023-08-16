//
//  PasswordRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation
import KeychainAccess

protocol PasswordRepositoryInterface {
    func fetchAccountID() -> String
    func fetchPassword() -> String
    func setAccountID(_ items: String)
    func setPassword(_ items: String)
}

final class PasswordOnKeyChainRepository: PasswordRepositoryInterface {
    static let shared = PasswordOnKeyChainRepository()

    private let KEY_cAccount = "KEY_cAccount"
    private var accountID: String {
        get { return getKeyChain(key: KEY_cAccount) }
        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
    }

    private let KEY_password = "KEY_password"
    private var password: String {
        get { return getKeyChain(key: KEY_password) }
        set(v) { setKeyChain(key: KEY_password, value: v) }
    }

    func fetchAccountID() -> String {
        return Self.shared.accountID
    }

    func fetchPassword() -> String {
        return Self.shared.password
    }

    func setAccountID(_ items: String) {
        Self.shared.accountID = items
    }

    func setPassword(_ items: String) {
        Self.shared.password = items
    }
}

extension PasswordOnKeyChainRepository {
    // MARK: - Private func
    /// KeychainAccess インスタンス
    private var keychain: Keychain {
        guard let identifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else {
            return Keychain(service: "")
        }
        return Keychain(service: identifier)
    }

    private func getKeyChain(key:String) -> String {
        do {
            if let value = try keychain.get(key) { return value }
        } catch {
            AKLog(level: .ERROR, message: "DataManager.getKeyChain catch")
        }
        return ""
    }

    private func setKeyChain(key:String, value:String) {
        do {
            try keychain
                .accessibility(Accessibility.alwaysThisDeviceOnly)  // 常時アクセス可能、デバイス限定
                .set(value, key: key)
        } catch {
            AKLog(level: .ERROR, message: "DataManager.setKeyChain catch")
        }
    }
}
