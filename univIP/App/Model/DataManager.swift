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
    
    /// JavaScriptを動かすかどうかのフラグ
    ///
    /// 次に読み込まれるURLはJavaScriptを動かすことを許可する
    /// これがないと、ログインに失敗した場合、永遠とログイン処理を行われてしまう
    public var canExecuteJavascript = false
    
    
    public var cAccount: String {
        get { return "c" + studentNumber.prefix(9)}
    }
    
    /// 学生番号の保存や読み取り
    private let KEY_studentNumber = "KEY_studentNumber"
    public var studentNumber: String {
        get { return getKeyChain(key: KEY_studentNumber) }
        set(v) { setKeyChain(key: KEY_studentNumber, value: v) }
    }
    
    /// passwordの保存や読み取り
    private let KEY_password = "KEY_password"
    public var password: String {
        get { return getKeyChain(key: KEY_password) }
        set(v) { setKeyChain(key: KEY_password, value: v) }
    }
    
    /// 利用規約のバージョン
    private let KEY_AgreementVersion = "KEY_agreementVersion"
    public var agreementVersion: String {
        get { return getUserDefaultsString(key: KEY_AgreementVersion) }
        set(v) { setUserDefaultsString(key: KEY_AgreementVersion, value: v) }
    }
    
    
    // MARK: - Private func
    
    /// KeychainAccess インスタンス
    private var keychain: Keychain {
        guard let identifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else {
            return Keychain(service: "")
        }
        return Keychain(service: identifier)
    }
    
    /// GET (keyChain)
    /// - Parameter key: 取得したい文字列のキー
    /// - Returns: キーに対応する復号化した文字列
    private func getKeyChain(key:String) -> String {
        do {
            if let value = try keychain.get(key) {
                return value
            }
        } catch {
            AKLog(level: .ERROR, message: "error: DataManager.getKeyChain catch")
        }
        return ""
    }
    
    /// SET (keyChain)
    /// - Parameters:
    ///   - key: 保存したい文字列のキー
    ///   - value: 暗号化し保存したい文字列
    private func setKeyChain(key:String, value:String) {
        do {
            try keychain
                .accessibility(Accessibility.alwaysThisDeviceOnly)  // 常時アクセス可能、デバイス限定
                .set(value, key: key)
        } catch {
            AKLog(level: .ERROR, message: "error: DataManager.setKeyChain catch")
            return
        }
    }
    
    
    /// GET (UserDefaults) String
    /// - Parameter key: 取得したい文字列のキー
    /// - Returns: キーに対応する文字列
    private func getUserDefaultsString(key:String) -> String {
        if let value = userDefaults.string(forKey: key) {
            return value
        }
        return "" // 非登録者の場合
    }
    
    /// SET (UserDefaults) String
    /// - Parameters:
    ///   - key: 保存したい文字列のキー
    ///   - value: 保存したい文字列
    private func setUserDefaultsString(key:String, value:String) {
        userDefaults.set(value ,forKey: key)
    }
    
    /// GET (UserDefaults) Bool
    /// - Parameter key: 取得したいフラグのキー
    /// - Returns: キーに対応するフラグ
    private func getUserDefaultsBool(key:String) -> Bool {
        // 非登録者(nilでも)はfalseを返す
        let value = userDefaults.bool(forKey: key)
        return value
    }
    
    /// SET (UserDefaults) Bool
    /// - Parameters:
    ///   - key: 保存したいフラグのキー
    ///   - value: 保存したいフラグ
    private func setUserDefaultsBool(key:String, value:Bool) {
        userDefaults.set(value ,forKey: key)
    }
}
