//
//  module.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import Foundation

final class Model: NSObject {
    
    /// 許可するドメイン
    let allowDomains = ["tokushima-u.ac.jp",
                        "microsoftonline.com",
                        "office365.com",
                        "office.com",
                        "tokudai-syusyoku.com"]
    
        
    // 教務事務システム -> 個人向けメッセージ -> PDF開く際、 safariで
//    let transitionURLs = ["https://eweb.stud.tokushima-u.ac.jp/Portal/CommonControls/Message/MesFileDownload.aspx?param="]
    
    
    /// メール設定
    let mailMasterAddress = "tokumemo1@gmail.com"
    let mailSendTitle = "トクメモ開発者へ"
    let mailSendFailureText = "送信に失敗しました。失敗が続く場合は[tokumemo1@gmail.com]へ連絡をしてください。"
    
    var serviceCellLists: [CellList] = [CellList(id:0,  name: "Webサイト",      category: "図書館",        display: true),
                                        CellList(id:1,  name: "貸し出し期間延長", category: "図書館",        display: true),
                                        CellList(id:2,  name: "本購入リクエスト", category: "図書館",        display: true),
                                        CellList(id:3,  name: "開館カレンダー",   category: "図書館",        display: true),
                                        CellList(id:4,  name: "シラバス",        category: "シラバス",      display: true),
                                        CellList(id:5,  name: "時間割",         category: "教務事務システム", display: true),
                                        CellList(id:6,  name: "今年の成績表",    category: "教務事務システム", display: true),
                                        CellList(id:7,  name: "成績参照",       category: "教務事務システム", display: true),
                                        CellList(id:8,  name: "出欠記録",       category: "教務事務システム", display: true),
                                        CellList(id:9,  name: "授業アンケート",  category: "教務事務システム", display: true),
                                        CellList(id:10, name: "メール",         category: "Outlook",      display: true),
                                        CellList(id:11, name: "マナバPC版",     category: "manaba",        display: true),
                                        CellList(id:12, name: "キャリア支援室",  category: "就職活動",       display: true),
                                        CellList(id:13, name: "履修登録",       category: "教務事務システム", display: true)]
    
    var settingCellLists: [CellList] = [CellList(id:100, name: "パスワード", category: "", display: true),
                                        CellList(id:101, name: "このアプリについて", category: "", display: true)]
    
    
    // Sectionのタイトル
    let sectionList: NSArray = [
        "サービス",
        "設定"]
    
    let agreementVersion = "aV_1"
}

struct structURL: Codable {
    let url: String
    let topView: Bool
}

struct CellList: Codable {
    let id: Int
    let name: String
    let category: String
    var display: Bool
}


