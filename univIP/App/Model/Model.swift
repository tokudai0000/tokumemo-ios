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
    public let allowedDomains = ["tokushima-u.ac.jp",
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
        case courceManagementHomePC
        case courceManagementHomeMobile
        case manabaHomePC
        case manabaHomeMobile
        case libraryWebHomePC               // 図書館Webサイト常三島
        case libraryWebHomeKuraPC           // 図書館Webサイト蔵本
        case libraryWebHomeMobile
        case libraryMyPage                  // 図書館MyPage
        case libraryBookLendingExtension    // 図書館本貸出し期間延長
        case libraryBookPurchaseRequest     // 図書館本購入リクエスト
        case libraryCalendar                // 図書館カレンダー常三島
        case libraryCalendarKura            // 図書館カレンダー蔵本
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
        
        case cellSort                       // 並び替え
        case firstViewSetting               // 初期画面設定
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
    public let serviceCellLists = [CellList(type: .courceManagementHomePC,      url: Url.courceManagementHomePC.string(),      title: "教務事務システムPC版"),
                                   CellList(type: .courceManagementHomeMobile,  url: Url.courceManagementHomeMobile.string(),  title: "教務事務システムMobile版"),
                                   CellList(type: .manabaHomePC,                url: Url.manabaHomePC.string(),                title: "マナバPC版"),
                                   CellList(type: .manabaHomeMobile,            url: Url.manabaHomeMobile.string(),            title: "マナバMobile版"),
                                   CellList(type: .libraryWebHomePC,            url: Url.libraryHomePC.string(),               title: "[図書館常三島]WebサイトPC版"),
                                   CellList(type: .libraryWebHomePC,            url: Url.libraryHomePC.string(),               title: "[図書館蔵本]WebサイトPC版"),
                                   CellList(type: .libraryWebHomeMobile,        url: Url.libraryHomeMobile.string(),           title: "[図書館常三島]WebサイトMobile版"),
                                   CellList(type: .libraryMyPage,               url: Url.libraryLogin.string(),                title: "[図書館]MyPage"),
                                   CellList(type: .libraryBookLendingExtension, url: Url.libraryBookLendingExtension.string(), title: "[図書館]貸し出し期間延長"),
                                   CellList(type: .libraryBookPurchaseRequest,  url: Url.libraryBookPurchaseRequest.string(),  title: "[図書館]本購入リクエスト"),
                                   CellList(type: .libraryCalendar,             url: Url.libraryCalendar.string(),             title: "[図書館常三島]開館カレンダー"),
                                   CellList(type: .libraryCalendarKura,         url: Url.libraryCalendar.string(),             title: "[図書館蔵本]開館カレンダー"),
                                   CellList(type: .syllabus,                    url: Url.syllabus.string(),                    title: "シラバス"),
                                   CellList(type: .timeTable,                   url: Url.timeTable.string(),                   title: "時間割"),
                                   CellList(type: .currentTermPerformance,      url: Url.currentTermPerformance.string(),      title: "今年の成績表"),
                                   CellList(type: .termPerformance,             url: Url.termPerformance.string(),             title: "成績参照"),
                                   CellList(type: .presenceAbsenceRecord,       url: Url.presenceAbsenceRecord.string(),       title: "出欠記録"),
                                   CellList(type: .classQuestionnaire,          url: Url.classQuestionnaire.string(),          title: "授業アンケート"),
                                   CellList(type: .mailService,                 url: Url.mailService.string(),                 title: "メール"),
                                   CellList(type: .tokudaiCareerCenter,         url: Url.tokudaiCareerCenter.string(),         title: "キャリア支援室"),
                                   CellList(type: .courseRegistration,          url: Url.courseRegistration.string(),          title: "履修登録"),
                                   CellList(type: .systemServiceList,           url: Url.systemServiceList.string(),           title: "システムサービス一覧"),
                                   CellList(type: .eLearningList,               url: Url.eLearningList.string(),               title: "Eラーニング一覧"),
                                   CellList(type: .universityWeb,               url: Url.universityHome.string(),              title: "大学サイト")]
    
    public let settingCellLists = [CellList(type: .cellSort,                                                                   title: "並び替え・編集"),
                                   CellList(type: .firstViewSetting,                                                           title: "初期画面設定"),
                                   CellList(type: .password,                                                                   title: "パスワード"),
                                   CellList(type: .aboutThisApp,                                                               title: "このアプリについて")]
    
    /// 初期画面に設定しても問題ないやつ
    static public let firstViewPickerLists = [CellList(type: .courceManagementHomePC,     title: "教務事務システムPC版"),
                                              CellList(type: .courceManagementHomeMobile, title: "教務事務システムMobile版"),
                                              CellList(type: .manabaHomePC,               title: "マナバPC版"),
                                              CellList(type: .manabaHomeMobile,           title: "マナバMobile版"),
                                              CellList(type: .libraryWebHomePC,                 title: "[図書館]Webサイト"),
                                              CellList(type: .libraryMyPage,              title: "[図書館]MyPage"),
                                              CellList(type: .libraryCalendar,            title: "[図書館]開館カレンダー"),
                                              CellList(type: .syllabus,                   title: "シラバス"),
                                              CellList(type: .mailService,                title: "メール"),
                                              CellList(type: .tokudaiCareerCenter,        title: "キャリア支援室"),
                                              CellList(type: .systemServiceList,          title: "システムサービス一覧"),
                                              CellList(type: .eLearningList,              title: "Eラーニング一覧"),
                                              CellList(type: .universityWeb,              title: "大学サイト")]
}

/// - CellList:
///   - id             : タップ時にどのCellか判定するid
///   - title          : Cellのタイトル
///   - category  : Cellのサブタイトル
///   - isDisplay : Cellに表示するか決定
struct CellList: Codable {
    let type: Model.SettingCellList
    var url: String = ""
    var isDisplay: Bool = true
    var initialView: Bool = false
    var title: String
}
