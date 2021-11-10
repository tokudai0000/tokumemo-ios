//
//  DataManager.swift
//  共通データ管理
//
//  Created by Akihiro Matsuyama on 2021/08/10.
//  Copyright © 2021年　akidon0000
//

import Foundation
import KeychainAccess


final class DataManager {
    
    static let singleton = DataManager() // シングルトン・インタンス
    
    public var cAccount = "c611821006"
    public var password = "q2KF2ZaxPtkL7Uu"
    public var passedCertification = false // ログインできていることを保証
    
    public var allCellList:[[CellList]] =  [[], []]
    
    /// KeychainAccess インスタンス
    var keychain: Keychain {
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
            // エラー処理
            print("error: Datamanager.setKeyChain")
            return
        }
    }
    
    /// デバイスID (keyChain)
    private let KEY_deviceId = "KEY_deviceId"
    var deviceId: String {
        get { return getKeyChain(key: KEY_deviceId) }
        set(v) { setKeyChain(key: KEY_deviceId, value: v) }
    }
    
//    /// cAccount
//    private let KEY_cAccount = "KEY_cAccount"
//    var cAccount: String {
//        get { return getKeyChain(key: KEY_cAccount) }
//        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
//    }
//
//    /// passWord
//    private let KEY_passWord = "KEY_passWord"
//    var password: String {
//        get { return getKeyChain(key: KEY_passWord) }
//        set(v) { setKeyChain(key: KEY_passWord, value: v) }
//    }
    
    // シングルトン・インスタンスの初期処理
    private init() {  //シングルトン保証// privateにすることにより他から初期化させない
        
    }
}
