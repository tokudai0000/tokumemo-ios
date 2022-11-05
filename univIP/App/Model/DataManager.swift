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
    
    public var teacherName = ""
    public var subjectName = ""
    
    public var weatherDatas:[String] = ["error","","http://example.com"]
    public var newsTitleDatas:[String] = []
    public var newsDateDatas:[String] = []
    
    /// JavaScriptを動かすかどうかのフラグ
    ///
    /// 次に読み込まれるURLはJavaScriptを動かすことを許可する
    /// これがないと、ログインに失敗した場合、永遠とログイン処理を行われてしまう
    public var canExecuteJavascript = false
    
    /// メニューリストの内容
    ///
    /// MenuViewControllerのメニューリストに表示させる内容
    /// 参照するたびに、UserDefaultsから保存したデータを読み込む
    public var menuLists:[Constant.Menu] =  []
    private init() {
//        menuLists = loadMenuLists()
    }
    
    /// メニューリストを保存
    ///
    /// UserDefaultsに保存
    /// 配列 -> Json -> Data にパースする必要がある
    public func saveMenuLists() {
//        let jsonEncoder = JSONEncoder()
//        guard let data = try? jsonEncoder.encode(menuLists) else { return }
//        setUserDefaultsData(key: KEY_menuLists, value: data)
    }
    
    /// cAccountの保存や読み取り
    private let KEY_cAccount = "KEY_cAccount"
    public var cAccount: String {
        get { return getKeyChain(key: KEY_cAccount) }
        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
    }
    
    /// passwordの保存や読み取り
    /// - Note:
    ///   KEY_password にするべきだが変更するとユーザーは再度パスワードを登録しなければならないため注意
    private let KEY_password = "KEY_passWord"
    public var password: String {
        get { return getKeyChain(key: KEY_password) }
        set(v) { setKeyChain(key: KEY_password, value: v) }
    }
    
    private var userDefaults = UserDefaults.standard
    
    /// KeychainAccess インスタンス
    private var keychain: Keychain {
        guard let identifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String else {
            return Keychain(service: "")
        }
        return Keychain(service: identifier)
    }
    
    // MARK: - Private func
    /// GET (UserDefaults) String
    /// - Parameter key: 取得したい文字列のキー
    /// - Returns: キーに対応する文字列
    public func getUserDefaultsString(key:String) -> String {
        if let value = userDefaults.string(forKey: key) {
            return value
        }
        return "" // 非登録者の場合
    }
    
    /// SET (UserDefaults) String
    /// - Parameters:
    ///   - key: 保存したい文字列のキー
    ///   - value: 保存したい文字列
    public func setUserDefaultsString(key:String, value:String) {
        userDefaults.set(value ,forKey: key)
    }
    
    
    /// 利用規約のバージョン
    private let KEY_AgreementVersion = "KEY_agreementVersion"
    public var agreementVersion: String {
        get { return getUserDefaultsString(key: KEY_AgreementVersion) }
        set(v) { setUserDefaultsString(key: KEY_AgreementVersion, value: v) }
    }
    
    /// チュートリアルを表示するべきかのフラグ
    /// - Note:
    ///   初回ユーザーはUserDefaultsにデータが入っていないので、falseが帰ってくる
    private let KEY_hadDoneTutorial = "KEY_hadDoneTutorial"
    public var hadDoneTutorial: Bool {
        get { return getUserDefaultsBool(key: KEY_hadDoneTutorial) }
        set(v) { setUserDefaultsBool(key: KEY_hadDoneTutorial, value: v) }
    }
    
    // MARK: - Private func
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
    
    /// GET (UserDefaults) Data
    /// - Parameter key: 取得したいデータのキー
    /// - Returns: キーに対応するデータ
    private func getUserDefaultsData(key:String) -> Data {
        if let value = userDefaults.data(forKey: key) {
            return value
        }
        return Data() // 非登録者の場合
    }
    
    /// SET (UserDefaults) Data
    /// - Parameters:
    ///   - key: 保存したいデータのキー
    ///   - value: 保存したいデータ
    private func setUserDefaultsData(key:String, value:Data) {
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
    
    /// 保存していたメニューリストを読み込む
    ///
    /// - Note:
    ///   毎回更新を行う
    /// - Returns: 更新したメニューリストの配列を返す
    private let KEY_menuLists = "KEY_menuLists"
//    private func loadMenuLists() -> [Constant.Menu] {
        // UserDefaultsから読み込む
        // Data -> Json -> 配列 にパースする必要がある
//        let jsonDecoder = JSONDecoder()
//        let data = getUserDefaultsData(key: KEY_menuLists)
//        guard let lists = try? jsonDecoder.decode([Constant.Menu].self, from: data) else {
//            // 初回利用者は初期値を返す
//            return Constant.initMenuLists
//        }
        
//        // アップデートごとに機能追加等があるため、更新する
//        var newModelLists = Constant.initMenuLists
//        var updateForLists:[Constant.Menu] = []
//
//        for oldList in lists {
//            // 並び順を保持する
//            if let index = newModelLists.firstIndex(where: {$0.id == oldList.id}) {
//                // 引き継ぎ
//                newModelLists[index].title = oldList.title             // ユーザーが指定した名前
//                newModelLists[index].isDisplay = oldList.isDisplay     // ユーザーが指定した表示
//                newModelLists[index].isInitView = oldList.isInitView   // ユーザーが指定した初期画面
//                updateForLists.append(newModelLists[index])
//                newModelLists.remove(at: index)
//            }
//
//            // お気に入りの場合、ユーザーによって変化するため、そのまま引き継ぐ
//            if oldList.id == .favorite {
//                // 引き継ぎ
//                updateForLists.append(oldList)
//            }
//        }
//
//        // 新規実装があれば通る
//        updateForLists.append(contentsOf: newModelLists)
        
//        return updateForLists
//    }
}
