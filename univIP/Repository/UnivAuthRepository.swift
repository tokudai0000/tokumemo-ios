//
//  UnivAuthRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation
import KeychainAccess

public protocol UnivAuthRepositoryInterface {
    func fetchUnivAuth() -> UnivAuth
    func setUnivAuth(_ items: UnivAuth)
}

public final class UnivAuthOnKeyChainRepository: UnivAuthRepositoryInterface {
    public static let shared = UnivAuthOnKeyChainRepository()

    public init() {}
    
    private let KEY_cAccount = "KEY_cAccount"
    private var accountCID: String {
        get { return getKeyChain(key: KEY_cAccount) }
        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
    }

    private let KEY_password = "KEY_password"
    private var password: String {
        get { return getKeyChain(key: KEY_password) }
        set(v) { setKeyChain(key: KEY_password, value: v) }
    }

    public func fetchUnivAuth() -> UnivAuth {
        let accountCID = Self.shared.accountCID
        let password = Self.shared.password
        return UnivAuth(accountCID: accountCID, password: password)
    }

    public func setUnivAuth(_ items: UnivAuth) {
        Self.shared.accountCID = items.accountCID
        Self.shared.password = items.password
    }
}

extension UnivAuthOnKeyChainRepository {
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
//            AKLog(level: .ERROR, message: "DataManager.getKeyChain catch")
        }
        return ""
    }

    private func setKeyChain(key:String, value:String) {
        do {
            try keychain
                .accessibility(Accessibility.alwaysThisDeviceOnly)  // 常時アクセス可能、デバイス限定
                .set(value, key: key)
        } catch {
//            AKLog(level: .ERROR, message: "DataManager.setKeyChain catch")
        }
    }
}
