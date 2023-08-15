//
//  PasswordRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation
import KeychainAccess

protocol PasswordRepositoryInterface {
    func fetchCAccount() -> String
    func fetchPassword() -> String
    func assignmentCACount(_ items: String)
    func assignmentPassword(_ items: String)
}

/// クラスプロパティで保持するクラス
final class PasswordOnKeyChainRepository: PasswordRepositoryInterface {

    static var shared = PasswordOnKeyChainRepository()

    private let KEY_cAccount = "KEY_cAccount"
    var cAccount: String {
        get { return getKeyChain(key: KEY_cAccount) }
        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
    }

    private let KEY_password = "KEY_password"
    var password: String {
        get { return getKeyChain(key: KEY_password) }
        set(v) { setKeyChain(key: KEY_password, value: v) }
    }

    func fetchCAccount() -> String {
        return Self.shared.cAccount
    }

    func fetchPassword() -> String {
        return Self.shared.password
    }

    func assignmentCACount(_ items: String) {
        return Self.shared.cAccount = items
    }

    func assignmentPassword(_ items: String) {
        return Self.shared.password = items
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
