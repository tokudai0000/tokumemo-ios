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
    private init() {} // インスタンスが1つであることを補償
    
    
    private var userDefaults = UserDefaults.standard
    
    
    public var menuLists:[[Constant.Menu]] =  [[], []]
    
    
    private var im_displayUrlString = ""
    public var displayUrlString: String {
        get { return im_displayUrlString }
        set(v) {
            // 1つ前のURLを保持
            im_forwardDisplayUrlString = im_displayUrlString
            im_displayUrlString = v
            
            AKLog(level: .DEBUG, message: "\n displayURL: \(im_displayUrlString)")
        }
    }
    
    private var im_forwardDisplayUrlString = ""
    public var forwardDisplayUrlString: String {
        // 外部から書き換え禁止
        get { return im_forwardDisplayUrlString }
    }
    
    
    
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
            return ""
        } catch {
            AKLog(level: .ERROR, message: "error: DataManager.getKeyChain catch")
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
    private let KEY_password = "KEY_passWord" // KEY_password にするべき(**注意** 変更するとユーザーは再度パスワードを登録しなければならない)
    public var password: String {
        get { return getKeyChain(key: KEY_password) }
        set(v) { setKeyChain(key: KEY_password, value: v) }
    }
    
    
    
    /// GET (UserDefaults) String
    private func getUserDefaultsString(key:String) -> String {
        if let value = userDefaults.string(forKey: key) {
            return value
        }
        return "" // 非登録者の場合
    }
    
    /// SET (UserDefaults) String
    private func setUserDefaultsString(key:String, value:String) {
        userDefaults.set(value ,forKey: key)
    }
    
    /// 利用規約のバージョン
    private let KEY_AgreementVersion = "KEY_AgreementVersion" // KEY_agreementVersion にするべき(**注意** 変更すると再度利用規約が表示される)
    public var agreementVersion: String {
        get { return getUserDefaultsString(key: KEY_AgreementVersion) }
        set(v) { setUserDefaultsString(key: KEY_AgreementVersion, value: v) }
    }
    
    private let KEY_initialViewName = "KEY_initialViewName"
    public var initialViewName: String {
        get { return getUserDefaultsString(key: KEY_initialViewName) }
        set(v) { setUserDefaultsString(key: KEY_initialViewName, value: v) }
    }
    
    
    
    /// GET (UserDefaults) Data
    private func getUserDefaultsData(key:String) -> Data {
        if let value = userDefaults.data(forKey: key) {
            return value
        }
        return Data() // 非登録者の場合
    }
    
    /// SET (UserDefaults) Data
    private func setUserDefaultsData(key:String, value:Data) {
        userDefaults.set(value ,forKey: key)
    }
        
    private let KEY_serviceLists = "KEY_settingCellList"
    public var serviceLists: [Constant.Menu] {
        get {
            let jsonDecoder = JSONDecoder()
            let data = getUserDefaultsData(key: KEY_serviceLists)
            guard let bookmarks = try? jsonDecoder.decode([Constant.Menu].self, from: data) else { return Constant.initServiceLists }
            return bookmarks
        }
        set(v) {
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(v) else { return }
            setUserDefaultsData(key: KEY_serviceLists, value: data)
        }
    }
}
