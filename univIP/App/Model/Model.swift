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
                                   CellList(id: 7,  title: "今期の成績表",    category: "教務事務システム", isDisplay: true),
                                   CellList(id: 8,  title: "これまでの成績",       category: "教務事務システム", isDisplay: true),
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

//enum SettingCellList {
//    case libraryWeb                     // 図書館Webサイト
//    case libraryMyPage                  // 図書館MyPage
//    case libraryBookLendingExtension    // 図書館本貸出し期間延長
//    case libraryBookPurchaseRequest     // 図書館本購入リクエスト
//    case libraryCalendar                // 図書館カレンダー
//    case syllabus                       // シラバス
//    case timeTable                      // 時間割
//    case currentTermPerformance         // 今年の成績表
//    case termPerformance                // 成績参照
//    case presenceAbsenceRecord          // 出欠記録
//    case classQuestionnaire             // 授業アンケート
//    case mailService                    // メール
//    case tokudaiCareerCenter            // キャリアセンター
//    case courseRegistration             // 履修登録
//    case systemServiceList              // システムサービス一覧
//    case eLearningList                  // Eラーニング一覧
//    case universityWeb                  // 大学サイト
//
//    case password                       // パスワード
//    case aboutThisApp                   // このアプリについて
//}
//
//enum Category {
//    case library
//    case corceManagement
//    case syllabus
//    case mail
//    case recruit
//    case setting
//}

//public let serviceCellLists = [CellList(id: .libraryWeb,                  isDisplay: true, category: .library,         title: "図書館Webサイト"),
//                               CellList(id: .libraryMyPage,               isDisplay: true, category: .library,         title: "図書館MyPage"),
//                               CellList(id: .libraryBookLendingExtension, isDisplay: true, category: .library,         title: "貸し出し期間延長"),
//                               CellList(id: .libraryBookPurchaseRequest,  isDisplay: true, category: .library,         title: "本購入リクエスト"),
//                               CellList(id: .libraryCalendar,             isDisplay: true, category: .library,         title: "開館カレンダー"),
//                               CellList(id: .syllabus,                    isDisplay: true, category: .syllabus,        title: "シラバス"),
//                               CellList(id: .timeTable,                   isDisplay: true, category: .corceManagement, title: "時間割"),
//                               CellList(id: .currentTermPerformance,      isDisplay: true, category: .corceManagement, title: "今年の成績表"),
//                               CellList(id: .termPerformance,             isDisplay: true, category: .corceManagement, title: "成績参照"),
//                               CellList(id: .presenceAbsenceRecord,       isDisplay: true, category: .corceManagement, title: "出欠記録"),
//                               CellList(id: .classQuestionnaire,          isDisplay: true, category: .corceManagement, title: "授業アンケート"),
//                               CellList(id: .mailService,                 isDisplay: true, category: .mail,            title: "メール"),
//                               CellList(id: .tokudaiCareerCenter,         isDisplay: true, category: .recruit,         title: "キャリア支援室"),
//                               CellList(id: .courseRegistration,          isDisplay: true, category: .corceManagement, title: "履修登録"),
//                               CellList(id: .systemServiceList,           isDisplay: true, category: .corceManagement, title: "システムサービス一覧"),
//                               CellList(id: .eLearningList,               isDisplay: true, category: .corceManagement, title: "Eラーニング一覧"),
//                               CellList(id: .universityWeb,               isDisplay: true, category: .corceManagement, title: "大学サイト")]
//
//public let settingCellLists = [CellList(id: .password,                    isDisplay: true, category: .setting,         title: "パスワード"),
//                               CellList(id: .aboutThisApp,                isDisplay: true, category: .setting,         title: "このアプリについて")]

//switch cellId {
//case .libraryWeb: // 図書館Webサイト
//    let response = webViewModel.url(.libraryHome)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "ERROR")
//    }
//    delegate.navigationRightButtonOnOff(operation: .down)
//
//case .libraryMyPage: // 図書館MyPage
//    let response = webViewModel.url(.libraryLogin)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .down)
//
//case .libraryBookLendingExtension: // 貸し出し期間延長
//    let response = webViewModel.url(.libraryBookLendingExtension)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .down)
//
//
//case .libraryBookPurchaseRequest: // 本購入リクエスト
//    let response = webViewModel.url(.libraryBookPurchaseRequest)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .down)
//
//
//case .libraryCalendar: // 開館カレンダー
//    let response = webViewModel.url(.libraryCalendar)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "失敗しました")
//    }
//    delegate.navigationRightButtonOnOff(operation: .down)
//
//
//case .syllabus: // シラバス
//    delegate.popupView(scene: .syllabus)
//
//
//case .timeTable: // 時間割
//    let response = webViewModel.url(.timeTable)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .up)
//
//
//case .currentTermPerformance: // 今年の成績表
//    let response = webViewModel.url(.currentTermPerformance)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//
//
//case .termPerformance: // 成績参照
//    let response = webViewModel.url(.termPerformance)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .up)
//
//
//case .presenceAbsenceRecord: // 出欠記録
//    let response = webViewModel.url(.presenceAbsenceRecord)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .up)
//
//
//case .classQuestionnaire: // 授業アンケート
//    let response = webViewModel.url(.classQuestionnaire)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .up)
//
//
//case .mailService: // メール
//    let response = webViewModel.url(.mailService)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .down)
//
//
//case .tokudaiCareerCenter: // キャリア支援室
//    let response = webViewModel.url(.tokudaiCareerCenter)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "失敗しました")
//    }
//    delegate.navigationRightButtonOnOff(operation: .down)
//
//
//case .courseRegistration: // 履修登録
//    let response = webViewModel.url(.courseRegistration)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .up)
//
//
//case .systemServiceList: // システムサービス一覧
//    let response = webViewModel.url(.systemServiceList)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .up)
//
//
//case .eLearningList: // Eラーニング一覧
//    let response = webViewModel.url(.eLearningList)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .up)
//
//
//case .universityWeb: // 大学サイト
//    let response = webViewModel.url(.universityHome)
//    if let url = response as URLRequest? {
//        delegate.wkWebView.load(url)
//    } else {
//        delegate.toast(message: "登録者のみ")
//    }
//    delegate.navigationRightButtonOnOff(operation: .up)
//
//
//case .password: // パスワード設定
//    delegate.popupView(scene: .password)
//
//
//case .aboutThisApp: // このアプリについて
//    delegate.popupView(scene: .aboutThisApp)
//
//
//default:
//    return
//}
