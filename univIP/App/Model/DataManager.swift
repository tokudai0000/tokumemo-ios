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
    private init() {
        // インスタンスが1つであることを補償
        menuLists = loadMenuLists()
    }
    
    private var userDefaults = UserDefaults.standard
    
    // 毎回UserDefaultsから取ってきて保存する
    public var menuLists:[Constant.Menu] =  []
    
    // JavaScriptを実行するかどうか
    public var isExecuteJavascript = false

    
    /// MenuLists内の要素を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - row: index
    ///   - title: タイトルの変更
    ///   - isDisplay: リストで表示する
    ///   - isInitView: 初期画面にする
    public func changeContentsMenuLists(row: Int, title: String? = nil, isDisplay: Bool? = nil, isInitView: Bool? = nil) {
        
        if let title = title {
            menuLists[row].title = title
        }
        if let isDisplay = isDisplay {
            menuLists[row].isDisplay = isDisplay
        }
        if let isInitView = isInitView {
            // falseに初期化する
            for i in 0..<menuLists.count { menuLists[i].isInitView = false }
            menuLists[row].isInitView = isInitView
        }
        saveMenuLists()
        
    }
    
    /// MenuLists内の順番を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - sourceRow: 移動させたいcellのindex
    ///   - destinationRow: 挿入場所のindex
    public func changeSortOderMenuLists(sourceRow: Int, destinationRow: Int) {
        
        let todo = menuLists[sourceRow]
        menuLists.remove(at: sourceRow)
        menuLists.insert(todo, at: destinationRow)
        saveMenuLists()
        
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
            AKLog(level: .ERROR, message: "error: DataManager.setKeyChain catch")
            return
        }
    }
    
    // cAccount
    private let KEY_cAccount = "KEY_cAccount"
    public var cAccount: String {
        get { return getKeyChain(key: KEY_cAccount) }
        set(v) { setKeyChain(key: KEY_cAccount, value: v) }
    }
    
    // password
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
    
    
    // 利用規約のバージョン
    private let KEY_AgreementVersion = "KEY_AgreementVersion" // KEY_agreementVersion にするべき(**注意** 変更すると再度利用規約が表示される)
    public var agreementVersion: String {
        get { return getUserDefaultsString(key: KEY_AgreementVersion) }
        set(v) { setUserDefaultsString(key: KEY_AgreementVersion, value: v) }
    }
    
    // 初期画面の設定
    private let KEY_initialViewName = "KEY_initialViewName"
    public var initialViewName: String {
        get { return getUserDefaultsString(key: KEY_initialViewName) }
        set(v) { setUserDefaultsString(key: KEY_initialViewName, value: v) }
    }
    
    // 前回利用した時間を保存
    private let KEY_saveTimeUsedLastTime = "KEY_saveTimeUsedLastTime"
    public var saveTimeUsedLastTime: String {
        get { return getUserDefaultsString(key: KEY_saveTimeUsedLastTime) }
        set(v) { setUserDefaultsString(key: KEY_saveTimeUsedLastTime, value: v) }
    }
    
    
    /// GET (UserDefaults) Bool
    private func getUserDefaultsBool(key:String) -> Bool {
        // 非登録者(nilでも)はfalseを返す
        let value = userDefaults.bool(forKey: key)
        return value
    }
    
    /// SET (UserDefaults) Bool
    private func setUserDefaultsBool(key:String, value:Bool) {
        userDefaults.set(value ,forKey: key)
    }
    
    // チュートリアルを終了したかのフラグ
    private let KEY_isFinishedMainTutorial = "KEY_isFinishedMainTutorial"
    public var isFinishedMainTutorial: Bool {
        get { return getUserDefaultsBool(key: KEY_isFinishedMainTutorial) }
        set(v) { setUserDefaultsBool(key: KEY_isFinishedMainTutorial, value: v) }
    }
    
    // チュートリアルを終了したかのフラグ
    private let KEY_isFinishedMenuTutorial = "KEY_isFinishedMenuTutorial"
    public var isFinishedMenuTutorial: Bool {
        get { return getUserDefaultsBool(key: KEY_isFinishedMenuTutorial) }
        set(v) { setUserDefaultsBool(key: KEY_isFinishedMenuTutorial, value: v) }
    }
    
    // password入力催促のフラグ(falseの時passwordSettingViewが出てくる)
    private let KEY_shouldInputedPassword = "KEY_shouldInputedPassword"
    public var shouldInputedPassword: Bool {
        get { return getUserDefaultsBool(key: KEY_shouldInputedPassword) }
        set(v) { setUserDefaultsBool(key: KEY_shouldInputedPassword, value: v) }
    }
    
    // メニューリストのカスタマイズ催促のフラグ
    private let KEY_shouldShowCustomizeMenu = "KEY_shouldShowCustomizeMenu"
    public var shouldShowCustomizeMenu: Bool {
        get { return getUserDefaultsBool(key: KEY_shouldShowCustomizeMenu) }
        set(v) { setUserDefaultsBool(key: KEY_shouldShowCustomizeMenu, value: v) }
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
    
    
    private let KEY_menuLists = "KEY_menuLists"
    private func loadMenuLists() -> [Constant.Menu] {
        // UserDefaultsから読み込む
        // Data -> Json -> 配列 にパースする必要がある
        let jsonDecoder = JSONDecoder()
        let data = getUserDefaultsData(key: KEY_menuLists)
        guard let lists = try? jsonDecoder.decode([Constant.Menu].self, from: data) else {
            // 初回利用者は初期値を返す
            return Constant.initServiceLists
        }
        
        // アップデートごとに機能追加等があるため、更新する
        var newModelLists = Constant.initServiceLists
        var updateForLists:[Constant.Menu] = []
        
        for oldList in lists {
            // 並び順を保持する
            if let index = newModelLists.firstIndex(where: {$0.id == oldList.id}) {
                // 引き継ぎ
                newModelLists[index].title = oldList.title             // ユーザーが指定した名前
                newModelLists[index].isDisplay = oldList.isDisplay     // ユーザーが指定した表示
                newModelLists[index].isInitView = oldList.isInitView   // ユーザーが指定した初期画面
                updateForLists.append(newModelLists[index])
                newModelLists.remove(at: index)
            }
        }
        
        // 新規実装があれば通る
        updateForLists.append(contentsOf: newModelLists)
        
        return updateForLists
    }

    public func saveMenuLists() {
        // UserDefaultsに保存
        // 配列 -> Json -> Data にパースする必要がある
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(menuLists) else { return }
        setUserDefaultsData(key: KEY_menuLists, value: data)
    }
    
}
