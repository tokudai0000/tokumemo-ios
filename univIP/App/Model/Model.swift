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
    public let agreementVersion = "1.0"
    /// 更新日時記録
    /// 1.0: 2021/11/14
    
    
    // MARK: - MainView
    
    /// 許可するドメイン
    /// tokushima-u.ac.jp:                                                 大学サイトのドメイン
    /// microsoftonline.com, office365.com, office.com:  outlook関連のドメイン
    /// tokudai-syusyoku.com:                                         キャリア支援室ドメイン
    /// youtube.com:                                                        大学サイトのYoutubeインライン再生に対応させる為
    public let allowDomains = ["tokushima-u.ac.jp",
                               "microsoftonline.com",
                               "office365.com",
                               "office.com",
                               "tokudai-syusyoku.com",
                               "youtube.com"]
    
    
    // MARK: -  SettingView
    
    /// Sectionのタイトル
    public let sectionLists = ["サービス",
                               "設定"]
    
    
    
    enum SettingCellList: Codable {
        case libraryWeb                     // 図書館Webサイト
        case libraryMyPage                  // 図書館MyPage
        case libraryBookLendingExtension    // 図書館本貸出し期間延長
        case libraryBookPurchaseRequest     // 図書館本購入リクエスト
        case libraryCalendar                // 図書館カレンダー
        case syllabus                       // シラバス
        case timeTable                      // 時間割
        case currentTermPerformance         // 今年の成績表
        case termPerformance                // 成績参照
        case presenceAbsenceRecord          // 出欠記録
        case classQuestionnaire             // 授業アンケート
        case mailService                    // メール
        case tokudaiCareerCenter            // キャリアセンター
        case courseRegistration             // 履修登録
        case systemServiceList              // システムサービス一覧
        case eLearningList                  // Eラーニング一覧
        case universityWeb                  // 大学サイト
        
        case password                       // パスワード
        case aboutThisApp                   // このアプリについて
    }
    
    enum Category: Codable {
        case library
        case corceManagement
        case syllabus
        case mail
        case recruit
        case setting
    }
    
    /// サービスCell初期状態（更新確認、初回利用者はここを確認される）
    public let serviceCellLists = [CellList(id: 0,  type: .libraryWeb,                  category: .library,         title: "[図書館]Webサイト"),
                                   CellList(id: 1,  type: .libraryMyPage,               category: .library,         title: "[図書館]MyPage"),
                                   CellList(id: 2,  type: .libraryBookLendingExtension, category: .library,         title: "[図書館]貸し出し期間延長"),
                                   CellList(id: 3,  type: .libraryBookPurchaseRequest,  category: .library,         title: "[図書館]本購入リクエスト"),
                                   CellList(id: 4,  type: .libraryCalendar,             category: .library,         title: "[図書館]開館カレンダー"),
                                   CellList(id: 5,  type: .syllabus,                    category: .syllabus,        title: "シラバス"),
                                   CellList(id: 6,  type: .timeTable,                   category: .corceManagement, title: "時間割"),
                                   CellList(id: 7,  type: .currentTermPerformance,      category: .corceManagement, title: "今年の成績表"),
                                   CellList(id: 8,  type: .termPerformance,             category: .corceManagement, title: "成績参照"),
                                   CellList(id: 9,  type: .presenceAbsenceRecord,       category: .corceManagement, title: "出欠記録"),
                                   CellList(id: 10, type: .classQuestionnaire,          category: .corceManagement, title: "授業アンケート"),
                                   CellList(id: 11, type: .mailService,                 category: .mail,            title: "メール"),
                                   CellList(id: 12, type: .tokudaiCareerCenter,         category: .recruit,         title: "キャリア支援室"),
                                   CellList(id: 13, type: .courseRegistration,          category: .corceManagement, title: "履修登録"),
                                   CellList(id: 14, type: .systemServiceList,           category: .corceManagement, title: "システムサービス一覧"),
                                   CellList(id: 15, type: .eLearningList,               category: .corceManagement, title: "Eラーニング一覧"),
                                   CellList(id: 16, type: .universityWeb,               category: .corceManagement, title: "大学サイト")]
    
    public let settingCellLists = [CellList(id: 100, type: .password,                   category: .setting,         title: "パスワード"),
                                   CellList(id: 101, type: .aboutThisApp,               category: .setting,         title: "このアプリについて")]
}

/// - CellList:
///   - id             : タップ時にどのCellか判定するid
///   - title          : Cellのタイトル
///   - category  : Cellのサブタイトル
///   - isDisplay : Cellに表示するか決定
struct CellList: Codable {
    let id: Int
    let type: Model.SettingCellList
    let category: Model.Category
    var isDisplay: Bool = true
    let title: String
}
