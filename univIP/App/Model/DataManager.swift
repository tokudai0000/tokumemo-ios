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
    public var menuLists:[[Constant.Menu]] =  [[], []]
    
    
    // 現在読み込んでいるURLを基点に処理の分岐を行う
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
    
    // 連続で表示されている時、ログインに失敗したと判定する場面があるため
    private var im_forwardDisplayUrlString = ""
    public var forwardDisplayUrlString: String {
        // 外部から書き換え禁止
        get { return im_forwardDisplayUrlString }
    }
    
    
    /// MenuLists内の要素を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - row: index
    ///   - title: タイトルの変更
    ///   - isDisplay: リストで表示する
    ///   - isInitView: 初期画面にする
    public func changeContentsMenuLists(row: Int, title: String? = nil, isDisplay: Bool? = nil, isInitView: Bool? = nil) {
        
        if let title = title {
            menuLists[0][row].title = title
        }
        if let isDisplay = isDisplay {
            menuLists[0][row].isDisplay = isDisplay
        }
        if let isInitView = isInitView {
            // falseに初期化する
            for i in 0..<menuLists[0].count { menuLists[0][i].isInitView = false }
            menuLists[0][row].isInitView = isInitView
        }
        saveMenuLists()
        
    }
    
    /// MenuLists内の順番を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - sourceRow: 移動させたいcellのindex
    ///   - destinationRow: 挿入場所のindex
    public func changeSortOderMenuLists(sourceRow: Int, destinationRow: Int) {
        
        let todo = menuLists[0][sourceRow]
        menuLists[0].remove(at: sourceRow)
        menuLists[0].insert(todo, at: destinationRow)
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
    private func loadMenuLists() -> [[Constant.Menu]] {
        // UserDefaultsから読み込む
        // Data -> Json -> 配列 にパースする必要がある
        let jsonDecoder = JSONDecoder()
        let data = getUserDefaultsData(key: KEY_menuLists)
        guard let lists = try? jsonDecoder.decode([Constant.Menu].self, from: data) else {
            // 初回利用者は初期値を返す
            return [Constant.initServiceLists, Constant.initSettingLists]
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
        
        return [updateForLists, Constant.initSettingLists]
    }

    private func saveMenuLists() {
        // UserDefaultsに保存
        // 配列 -> Json -> Data にパースする必要がある
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(menuLists[0]) else { return }
        setUserDefaultsData(key: KEY_menuLists, value: data)
        
    }
    
}
