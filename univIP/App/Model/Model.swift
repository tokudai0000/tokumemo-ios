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
    public let agreementVersion = "1.0.1"
    /// 更新日時記録
    /// 1.0.0: 2021/11/11
    
    
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
    
    
    
    enum SettingCellList {
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
    
    /// サービスCell初期状態（更新確認、初回利用者はここを確認される）
    public let serviceCellLists = [CellList(id: 0,  title: "[図書館]Webサイト", category: "図書館", isDisplay: true),
                                   CellList(id: 1,  title: "[図書館]MyPage", category: "図書館", isDisplay: true),
                                   CellList(id: 2,  title: "[図書館]貸し出し期間延長", category: "図書館", isDisplay: true),
                                   CellList(id: 3,  title: "[図書館]本購入リクエスト", category: "図書館", isDisplay: true),
                                   CellList(id: 4,  title: "[図書館]開館カレンダー",   category: "図書館", isDisplay: true),
                                   CellList(id: 5,  title: "シラバス",        category: "シラバス",      isDisplay: true),
                                   CellList(id: 6,  title: "時間割",         category: "教務事務システム", isDisplay: true),
                                   CellList(id: 7,  title: "今年の成績表",    category: "教務事務システム", isDisplay: true),
                                   CellList(id: 8,  title: "成績参照",       category: "教務事務システム", isDisplay: true),
                                   CellList(id: 9,  title: "出欠記録",       category: "教務事務システム", isDisplay: true),
                                   CellList(id: 10, title: "授業アンケート",  category: "教務事務システム", isDisplay: true),
                                   CellList(id: 11, title: "メール",         category: "Outlook",      isDisplay: true),
                                   CellList(id: 12, title: "キャリア支援室",  category: "就職活動",       isDisplay: true),
                                   CellList(id: 13, title: "履修登録",       category: "教務事務システム", isDisplay: true),
                                   CellList(id: 14, title: "システムサービス一覧", category: "教務事務システム", isDisplay: true),
                                   CellList(id: 15, title: "Eラーニング一覧", category: "教務事務システム", isDisplay: true),
                                   CellList(id: 16, title: "大学サイト", category: "教務事務システム", isDisplay: true)]
    
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
//    let id: Model.SettingCellList
    let title: String
    let category: String
    var isDisplay: Bool
}


//    public let serviceCellLists = [CellList(id: .libraryWeb,                  title: "図書館Webサイト", category: "図書館", isDisplay: true),
//                                   CellList(id: .libraryMyPage,               title: "図書館MyPage", category: "図書館", isDisplay: true),
//                                   CellList(id: .libraryBookLendingExtension, title: "貸し出し期間延長", category: "図書館", isDisplay: true),
//                                   CellList(id: .libraryBookPurchaseRequest,  title: "本購入リクエスト", category: "図書館", isDisplay: true),
//                                   CellList(id: .libraryCalendar,             title: "開館カレンダー", category: "図書館", isDisplay: true),
//                                   CellList(id: .syllabus,                    title: "シラバス", category: "シラバス", isDisplay: true),
//                                   CellList(id: .timeTable,                   title: "時間割", category: "教務事務システム", isDisplay: true),
//                                   CellList(id: .currentTermPerformance,      title: "今年の成績表", category: "教務事務システム", isDisplay: true),
//                                   CellList(id: .termPerformance,             title: "成績参照", category: "教務事務システム", isDisplay: true),
//                                   CellList(id: .presenceAbsenceRecord,       title: "出欠記録", category: "教務事務システム", isDisplay: true),
//                                   CellList(id: .classQuestionnaire,          title: "授業アンケート", category: "教務事務システム", isDisplay: true),
//                                   CellList(id: .mailService,                 title: "メール", category: "Outlook", isDisplay: true),
//                                   CellList(id: .tokudaiCareerCenter,         title: "キャリア支援室", category: "就職活動", isDisplay: true),
//                                   CellList(id: .courseRegistration,          title: "履修登録", category: "教務事務システム", isDisplay: true),
//                                   CellList(id: .systemServiceList,           title: "システムサービス一覧", category: "教務事務システム", isDisplay: true),
//                                   CellList(id: .eLearningList,               title: "Eラーニング一覧", category: "教務事務システム", isDisplay: true),
//                                   CellList(id: .universityWeb,               title: "大学サイト", category: "教務事務システム", isDisplay: true)]

//    public let settingCellLists = [CellList(id: .password,                    title: "パスワード", category: "", isDisplay: true),
//                                   CellList(id: .aboutThisApp,                title: "このアプリについて", category: "", isDisplay: true)]
