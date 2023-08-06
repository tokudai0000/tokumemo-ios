//
//  DataManager.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/10.
//  Copyright © 2021年　akidon0000
//

import Foundation
import KeychainAccess

protocol DataManagerInterface {

}

final class DataManager: DataManagerInterface {
    static let singleton = DataManager()

    private var userDefaults = UserDefaults.standard

    var syllabusTeacherName = ""
    var syllabusSubjectName = ""

    var prItemLists: [PrItem]

    init() {
        prItemLists = []
    }

    
    public var shouldRelogin = true
    struct LoginState {
        public var isProgress = false          // 進行中
        public var completeImmediately = false // 完了してすぐ
        public var completed = false           // ログイン完了
    }
    public var loginState:LoginState = LoginState()

    private let KEY_agreementVersion = "KEY_agreementVersion"
    var agreementVersion: String {
        get { return userDefaults.string(forKey: KEY_agreementVersion) ?? "" }
        set(v) { userDefaults.set(v ,forKey: KEY_agreementVersion) }
    }

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
