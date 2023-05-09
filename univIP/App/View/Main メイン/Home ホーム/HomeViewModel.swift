//
//  HomeViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Kanna
import Alamofire
import SwiftyJSON

class HomeViewModel {
    
    // 共通データ・マネージャ
    public let dataManager = DataManager.singleton
    
    // API マネージャ
    public let apiManager = ApiManager.singleton
        
    public var prItems: [PrData] = []
    
    public var displayPrItem: PrData?
    
    //MARK: - STATE ステータス
    
    enum State {
        case busy  // 準備中
        case ready // 準備完了
        case error // エラー発生
    }
    public var state: ((State) -> Void)?
    
    // MARK: - Public func
    
    /// TableCellの内容(isHiddon=trueを除く)
    public var displayMenuItemLists: [MenuItemList] {
        get{
            var displayLists:[MenuItemList] = []
            for item in dataManager.menuLists {
                if !item.isHiddon {
                    displayLists.append(item)
                }
            }
            return displayLists
        }
    }
    
    public func updatePrItems() {
        state?(.busy) // 通信開始（通信中）
        prItems.removeAll()
        apiManager.request(Url.prItemJsonData.string(),
                           success: { [weak self] (response) in
            guard let self = self else {
                fatalError()
            }
            let itemCounts = response["itemCounts"].int ?? 0
            for i in 0 ..< itemCounts {
                let item = response["items"][i]
                let prItem = PrData(imageURL: item["imageURL"].string,
                                    introduction: item["introduction"].string,
                                    tappedURL: item["tappedURL"].string,
                                    organizationName: item["organization_name"].string,
                                    description: item["description"].string)
                self.prItems.append(prItem)
            }
            self.state?(.ready) // 通信完了
        }, failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
            self?.state?(.error) // エラー表示
        })
    }
    
    /// prItemsをランダムに表示させるための関数
    /// prItemsの配列数が「0と1」の場合を除き、ランダムにPrData?を返す
    public func selectDispalyPrItem() -> PrData? {
        if prItems.count == 0 {
            return nil
        }else if prItems.count == 1 {
            return prItems[0]
        }
        while true {
            let randomNum = Int.random(in: 0..<prItems.count)
            if displayPrItem == nil {
                return prItems[randomNum]
            }
            if displayPrItem?.imageURL != prItems[randomNum].imageURL {
                return prItems[randomNum]
            }
        }
    }
    
    /// 大学図書館の種類
    enum LibraryType {
        case main // 常三島本館
        case kura // 蔵本分館
    }
    
    /**
     図書館の開館カレンダーPDFまでのURLRequestを作成する
     PDFへのURLは状況により変化する為、図書館ホームページからスクレイピングを行う
     例1：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021.pdf
     例2：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021_syuusei1.pdf
     ==HTML==[常三島(本館Main) , 蔵本(分館Kura)でも同様]
     <body class="index">
     <ul>
     <li class="pos_r">
     <a href="pub/pdf/calender/calender_main_2021.pdf title="開館カレンダー">
     ========
     aタグのhref属性を抽出、"pub/pdf/calender/"と一致していれば、例1のURLを作成する。
     - Parameter type: 常三島(本館Main) , 蔵本(分館Kura)のどちらの開館カレンダーを欲しいのかLibraryTypeから選択
     - Returns: 図書館の開館カレンダーPDFまでのString
     */
    public func makeLibraryCalendarUrl(type: LibraryType) -> String? {
        var urlString = ""
        switch type {
        case .main:
            urlString = Url.libraryHomePageMainPC.string()
        case .kura:
            urlString = Url.libraryHomePageKuraPC.string()
        }
        let url = URL(string: urlString)! // fatalError
        do {
            // URL先WebページのHTMLデータを取得
            let data = try NSData(contentsOf: url) as Data
            let doc = try HTML(html: data, encoding: String.Encoding.utf8)
            // タグ(HTMLでのリンクの出発点と到達点を指定するタグ)を抽出
            for node in doc.xpath("//a") {
                // 属性(HTMLでの目当ての資源の所在を指し示す属性)に設定されている文字列を出力
                if let str = node["href"] {
                    // 開館カレンダーは図書ホームページのカレンダーボタンにPDFへのURLが埋め込まれている
                    if str.contains("pub/pdf/calender/") {
                        // PDFまでのURLを作成する(本館のURLに付け加える)
                        return Url.libraryHomePageMainPC.string() + str
                    }
                }
            }
            AKLog(level: .ERROR, message: "[URL抽出エラー]: 図書館開館カレンダーURLの抽出エラー \n urlString:\(url.absoluteString)")
        } catch {
            AKLog(level: .ERROR, message: "[Data取得エラー]: 図書館開館カレンダーHTMLデータパースエラー\n urlString:\(url.absoluteString)")
        }
        return nil
    }
    
    /**
     今年度の成績表のURLを作成する
     
     - Note:
     2020年4月〜2021年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2020
     2021年4月〜2022年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2021
     なので、2022年の1月から3月まではURLがyear=2021とする必要あり
     - Returns: 今年度の成績表のURL
     */
    public func createCurrentTermPerformanceUrl() -> String {
        var year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        if month <= 3 {
            year -= 1
        }
        return Url.currentTermPerformance.string() + String(year)
    }
    
    /**
     JavaScriptを動かしたい指定のURLか判定
     ・JavaScriptを実行するフラグ
     ・cアカウント、パスワードの登録確認
     ・大学統合認証システム(IAS)のログイン画面の判定
     ・それ以外なら
     */
    public func canExecuteJS(_ urlString: String) -> Bool {
        if dataManager.canExecuteJavascript == false { return false }
        if dataManager.cAccount.isEmpty || dataManager.password.isEmpty { return false }
        if urlString.contains(Url.universityLogin.string()) { return true }
        return false
    }
}
