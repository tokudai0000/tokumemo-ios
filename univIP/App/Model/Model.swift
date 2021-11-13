//
//  model.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import Foundation

struct Model {
    
    /// 利用規約、ユーザーポリシーの更新したらバージョンあげること
    public let agreementVersion = "1.0.0."
    /// 更新日時記録
    /// 1.0.0: 2021/11/11
    
    
    // MARK: - MainView
    
    /// 許可するドメイン
    /// tokushima-u.ac.jp: 大学サイトのドメイン
    /// microsoftonline.com, office365.com, office.com: outlook関連のドメイン
    /// tokudai-syusyoku.com: キャリア支援室ドメイン
    public let allowDomains = ["tokushima-u.ac.jp",
                               "microsoftonline.com",
                               "office365.com",
                               "office.com",
                               "tokudai-syusyoku.com"]
    
    
    // MARK: -  SettingView
    
    /// Sectionのタイトル
    public let sectionLists = ["サービス",
                               "設定"]
    
    /// サービスCell初期状態（更新確認、初回利用者はここを確認される）
    public let serviceCellLists = [CellList(id:0,  title: "Webサイト",      category: "図書館",        isDisplay: true),
                                   CellList(id:1,  title: "貸し出し期間延長", category: "図書館",        isDisplay: true),
                                   CellList(id:2,  title: "本購入リクエスト", category: "図書館",        isDisplay: true),
                                   CellList(id:3,  title: "開館カレンダー",   category: "図書館",        isDisplay: true),
                                   CellList(id:4,  title: "シラバス",        category: "シラバス",      isDisplay: true),
                                   CellList(id:5,  title: "時間割",         category: "教務事務システム", isDisplay: true),
                                   CellList(id:6,  title: "今年の成績表",    category: "教務事務システム", isDisplay: true),
                                   CellList(id:7,  title: "成績参照",       category: "教務事務システム", isDisplay: true),
                                   CellList(id:8,  title: "出欠記録",       category: "教務事務システム", isDisplay: true),
                                   CellList(id:9,  title: "授業アンケート",  category: "教務事務システム", isDisplay: true),
                                   CellList(id:10, title: "メール",         category: "Outlook",      isDisplay: true),
                                   CellList(id:11, title: "マナバPC版",     category: "manaba",        isDisplay: true),
                                   CellList(id:12, title: "キャリア支援室",  category: "就職活動",       isDisplay: true),
                                   CellList(id:13, title: "履修登録",       category: "教務事務システム", isDisplay: true)]
    
    /// 設定Cell（固定）
    public let settingCellLists = [CellList(id:100, title: "パスワード",     category: "",             isDisplay: true),
                                   CellList(id:101, title: "このアプリについて", category: "",           isDisplay: true)]
    
}


/// - CellList:
///   - id             : タップ時にどのCellか判定するid
///   - title          : Cellのタイトル
///   - category  : Cellのサブタイトル
///   - isDisplay : Cellに表示するか決定
struct CellList: Codable {
    let id: Int
    let title: String
    let category: String
    var isDisplay: Bool
}


enum SettingCellList: String {
    case login                          // ログイン画面
    case courceManagementHomeSP         // 情報ポータル、ホーム画面URL
    case courceManagementHomePC         // 情報ポータル、ホーム画面URL
    case manabaSP                       // マナバURL
    case manabaPC                       // マナバURL
    case libraryLogin                   // 図書館URL
    case libraryBookLendingExtension    // 図書館本貸出し期間延長URL
    case libraryBookPurchaseRequest     // 図書館本購入リクエスト
    case libraryCalendar                // 図書館カレンダー
    case syllabus                       // シラバスURL
    case timeTable                      // 時間割
    case currentTermPerformance         // 今年の成績表
    case termPerformance                // 成績参照
    case presenceAbsenceRecord          // 出欠記録
    case classQuestionnaire             // 授業アンケート
    case mailService                    // MicroSoftのoutlookへ遷移
    case tokudaiCareerCenter            // キャリアセンター
    case courseRegistration             // 履修登録URL
    case systemServiceList              // システムサービス一覧
    case eLearningList                  // Eラーニング一覧
}
