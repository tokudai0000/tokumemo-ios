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
    
    static let singleton = DataManager() // シングルトン・インタンス
    private var userDefaults = UserDefaults.standard
    
    public var syllabusTeacherName = ""
    public var syllabusSubjectName = ""
    
    public var shouldRelogin = true
    public var isWebLoginCompleted = false // ログイン完了
    
    /// 次に読み込まれるURLはJavaScriptを動かすことを許可する
    /// これがないと、ログインに失敗した場合、永遠とログイン処理を行われてしまう
    public var canExecuteJavascript = false
    
    private let KEY_agreementVersion = "KEY_agreementVersion"
    public var agreementVersion: String {
        get { return userDefaults.string(forKey: KEY_agreementVersion) ?? "" }
        set(v) { userDefaults.set(v ,forKey: KEY_agreementVersion) }
    }
    
    /// 配列をUserDefaultsには保存できないので 配列 -> Json -> Data にパースし、保存する
    private let KEY_menuLists = "KEY_menuLists"
    public var menuLists: [MenuListItem] {
        get {
            let jsonDecoder = JSONDecoder()
            let data = userDefaults.data(forKey: KEY_menuLists) ?? Data()
            let lists = try? jsonDecoder.decode([MenuListItem].self, from: data)
            return lists ?? initMenuLists
        }
        set(v) {
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(v) else { return }
            userDefaults.set(data ,forKey: KEY_menuLists)
        }
    }
        
    private let KEY_cAccount = "KEY_cAccount"
    public var cAccount: String {
        get { return getKeyChain(key: KEY_cAccount) }
        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
    }
    
    private let KEY_password = "KEY_password"
    public var password: String {
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
