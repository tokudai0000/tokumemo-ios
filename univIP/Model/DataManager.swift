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

    public var prItemLists: [PrItem] = []
    
    public var syllabusTeacherName = ""
    public var syllabusSubjectName = ""
    
    public var shouldRelogin = true
    struct LoginState {
        public var isProgress = false          // 進行中
        public var completeImmediately = false // 完了してすぐ
        public var completed = false           // ログイン完了
    }
    public var loginState:LoginState = LoginState()
    
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
    //    public var menuLists: [MenuItemList] {
    //        get {
    //            let jsonDecoder = JSONDecoder()
    //            let data = userDefaults.data(forKey: KEY_menuLists) ?? Data()
    //            guard let lists = try? jsonDecoder.decode([MenuItemList].self, from: data) else{
    //                return initMenuLists
    //            }
    //            var initLists = initMenuLists
    //            var newLists:[MenuItemList] = []
    //            for oldList in lists {
    //                for i in 0..<initLists.count {
    //                    guard oldList.id == initLists[i].id else{
    //                        continue
    //                    }
    //                    // 新規initMenuListと変更点がないかを照らし合わせる
    //                    let item = MenuItemList(title: initLists[i].title,
    //                                            id: initLists[i].id,
    //                                            image: initLists[i].image,
    //                                            url: initLists[i].url,
    //                                            isLockIconExists: initLists[i].isLockIconExists,
    //                                            isHiddon: oldList.isHiddon)
    //
    //                    initLists.remove(at: i)
    //                    newLists.append(item)
    //                    break
    //                }
    //
    //                if oldList.id == .favorite {
    //                    // カスタマイズで入れた内容(ユーザー設定)
    //                    newLists.append(oldList)
    //                }
    //            }
    //
    //            return newLists + initLists
    //        }
    //        set(v) {
    //            let jsonEncoder = JSONEncoder()
    //            guard let data = try? jsonEncoder.encode(v) else { return }
    //            userDefaults.set(data ,forKey: KEY_menuLists)
    //        }
    //    }

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
