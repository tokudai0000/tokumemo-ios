//
//  DataManager.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/10.
//  Copyright © 2021年　akidon0000
//

import Foundation
import KeychainAccess

final class DataManager {
    
    ///
    /// アプリの共通データ（シングルトンのため、必ず同じインスタンスを参照している）
    ///
    public var forwardDisplayUrl = ""               // 1つ前のURL
    public var displayUrl = ""                      // 現在表示しているURL
    public var isLoggedIn = false                   // ログインしているか
    public var allCellList:[[CellList]] =  [[], []] // SettingViewのCell内容（ViewModelではその都度インスタンスが生成される為）
    public var isSyllabusSearchOnce = false           // Syllabusの検索を1度きりにする
    ///
    
    static let singleton = DataManager() // シングルトン・インタンス
    
    private let model = Model()
    private var userDefaults = UserDefaults.standard
    
    /// KeychainAccess インスタンス
    public var keychain: Keychain {
        guard let identifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else {
            return Keychain(service: "")
        }
        return Keychain(service: identifier)
    }
    
    /// GET (keyChain)
    private func getKeyChain(key:String) -> String {
        do {
            if let value = try keychain.get(key) {
                return value
            }
            AKLog(level: .ERROR, message: "error: Datamanager.getKeyChain do")
            return ""
        } catch {
            AKLog(level: .ERROR, message: "error: Datamanager.getKeyChain catch")
            return ""
        }
    }
    
    /// SET (keyChain)
    private func setKeyChain(key:String, value:String) {
        do {
            try keychain
                .accessibility(Accessibility.alwaysThisDeviceOnly)  // 常時アクセス可能、デバイス限定
                .set(value, key: key)
        } catch {
            AKLog(level: .ERROR, message: "error: Datamanager.setKeyChain")
            print("error: Datamanager.setKeyChain")
            return
        }
    }
    
    /// cAccount
    private let KEY_cAccount = "KEY_cAccount"
    public var cAccount: String {
        get { return getKeyChain(key: KEY_cAccount) }
        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
    }
    
    /// password
    private let KEY_passWord = "KEY_passWord"
    public var password: String {
        get { return getKeyChain(key: KEY_passWord) }
        set(v) { setKeyChain(key: KEY_passWord, value: v) }
    }
    
    
    /// agreementversion
    private let KEY_AgreementVersion = "KEY_AgreementVersion"
    public func setAgreementVersion() {
        userDefaults.set(model.agreementVersion ,forKey: KEY_AgreementVersion)
    }
    
    public func getAgreementVersion() -> String? {
        return userDefaults.string(forKey: KEY_AgreementVersion)
    }
    
    
    private let KEY_corceManagement = "KEY_corceManagement"
    public func setCorceManagement(word: String) {
        userDefaults.set(word, forKey: KEY_corceManagement)
    }
    
    public func getCorceManagement() -> String? {
        return userDefaults.string(forKey: KEY_corceManagement)
    }

    
    private let KEY_manaba = "KEY_manaba"
    public func setManabaId(word: String) {
        userDefaults.set(word, forKey: KEY_manaba)
    }
    
    public func getManaba() -> String? {
        return userDefaults.string(forKey: KEY_manaba)
    }
    
    
    private let KEY_settingCellList = "KEY_settingCellList"
    public func setSettingCellList(data: Data) {
        userDefaults.set(data, forKey: KEY_settingCellList)
    }
    
    public func getSettingCellList() -> Data? {
        return userDefaults.data(forKey: KEY_settingCellList)
    }
    
    
    private let KEY_version = "KEY_version"
    public func setVersion(word: String) {
        userDefaults.set(word, forKey: KEY_version)
    }
    
    public func getVersion() -> String? {
        return userDefaults.string(forKey: KEY_version)
    }
}
