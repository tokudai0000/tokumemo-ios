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
    
    
    
    /////////////////// menuについて
    
    // 毎回UserDefaultsから取ってきて保存する
    public var serviceLists:[ConstStruct.CollectionCell] =  []
    private init() {
        // インスタンスが1つであることを補償
        serviceLists = loadMenuLists()
    }
    
    /// MenuLists内の要素を追加する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - menuItem: 追加したいお気に入り設定
    public func addContentsMenuLists(menuItem: ConstStruct.CollectionCell) {
        serviceLists.append(menuItem)
        saveMenuLists()
    }
    
    /// MenuLists内の要素を削除する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - row: index
    public func deleteContentsMenuLists(row: Int) {
        serviceLists.remove(at: row)
        saveMenuLists()
    }
    
    /// MenuLists内の要素を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - row: index
    ///   - title: タイトルの変更
    ///   - isDisplay: リストで表示する
    ///   - isInitView: 初期画面にする
    public func changeContentsMenuLists(row: Int, isDisplay: Bool? = nil) {
//        if let isDisplay = isDisplay {
//            menuLists[row].isDisplay = isDisplay
//        }
        saveMenuLists()
    }
    
    /// MenuLists内の順番を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - sourceRow: 移動させたいcellのindex
    ///   - destinationRow: 挿入場所のindex
    public func changeSortOderMenuLists(sourceRow: Int, destinationRow: Int) {
        let todo = serviceLists[sourceRow]
        serviceLists.remove(at: sourceRow)
        serviceLists.insert(todo, at: destinationRow)
        saveMenuLists()
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
    
    
    private let KEY_menuLists = "KEY_ServiceLists"
    private func loadMenuLists() -> [ConstStruct.CollectionCell] {
        // UserDefaultsから読み込む
        // Data -> Json -> 配列 にパースする必要がある
        let jsonDecoder = JSONDecoder()
        let data = getUserDefaultsData(key: KEY_menuLists)
        guard let lists = try? jsonDecoder.decode([ConstStruct.CollectionCell].self, from: data) else {
            // 初回利用者は初期値を返す
            return ConstStruct.initCollectionCellLists
        }
        
        // アップデートごとに機能追加等があるため、更新する
        var newModelLists = ConstStruct.initCollectionCellLists
        var updateForLists:[ConstStruct.CollectionCell] = []
        
        for oldList in lists {
            // 並び順を保持する
            if let index = newModelLists.firstIndex(where: {$0.id == oldList.id}) {
                // 引き継ぎ
//                newModelLists[index].isDisplay = oldList.isDisplay     // ユーザーが指定した表示
                updateForLists.append(newModelLists[index])
                newModelLists.remove(at: index)
            }
            
            // お気に入りの場合、ユーザーによって変化するため、そのまま引き継ぐ
            if oldList.id == .favorite {
                // 引き継ぎ
                updateForLists.append(oldList)
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
        guard let data = try? jsonEncoder.encode(serviceLists) else { return }
        setUserDefaultsData(key: KEY_menuLists, value: data)
    }
}
