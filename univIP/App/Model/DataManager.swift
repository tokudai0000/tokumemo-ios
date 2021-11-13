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
    public var isSyllabusSearchOnce = true           // Syllabusの検索を1度きりにする
    ///
    
    static let singleton = DataManager() // シングルトン・インタンス
    
    
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
    
}
