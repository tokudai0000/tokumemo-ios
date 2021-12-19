//
//  model.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import Foundation

class Constant {
    
    // 利用規約バージョン
    static let agreementVersion = "1.0"
    
    // WebViewで読み込みを許可するドメイン
    static let allowedDomains = ["tokushima-u.ac.jp",    // 大学サイト
                                 "microsoftonline.com",  // outlook(メール)関連
                                 "office365.com",
                                 "office.com",
                                 "tokudai-syusyoku.com", // キャリア支援室
                                 "youtube.com"]          // 大学サイトのインライン再生に対応させる為
    
    enum MenuLists: Codable {
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
    
    struct Menu: Codable {
        var title: String
        let type: MenuLists
        var url: String = ""
        var isDisplay: Bool = true
        var initialView: Bool = false
        var canInitView: Bool = false
    }
    
    // サービスCell初期状態（更新確認、初回利用者はここを確認される）
    static let initServiceLists = [
        Menu(title: "教務事務システムPC版",
             type: .courceManagementHomePC,
             url: Url.courceManagementPC.string(),
             canInitView: true),
        
        Menu(title: "教務事務システムMobile版",
             type: .courceManagementHomeMobile,
             url: Url.courceManagementMobile.string(),
             canInitView: true),
        
        Menu(title: "マナバPC版",
             type: .manabaHomePC,
             url: Url.manabaPC.string(),
             initialView: true,         // デフォルトの初期画面
             canInitView: true),
        
        Menu(title: "マナバMobile版",
             type: .manabaHomeMobile,
             url: Url.manabaMobile.string(),
             canInitView: true),
        
        Menu(title: "[図書館常三島]WebサイトPC版",
             type: .libraryWebHomePC,
             url: Url.libraryHomePageMainPC.string(),
             canInitView: true),
        
        Menu(title: "[図書館蔵本]WebサイトPC版",
             type: .libraryWebHomePC,
             url: Url.libraryHomePageMainPC.string(),
             canInitView: true),
        
        Menu(title: "[図書館常三島]WebサイトMobile版",
             type: .libraryWebHomeMobile,
             url: Url.libraryHomeMobile.string(),
             canInitView: true),
        
        Menu(title: "[図書館]MyPage",
             type: .libraryMyPage,
             url: Url.libraryMyPage.string(),
             canInitView: true),
        
        Menu(title: "[図書館]貸し出し期間延長",
             type: .libraryBookLendingExtension,
             url: Url.libraryBookLendingExtension.string()),
        
        Menu(title: "[図書館]本購入リクエスト",
             type: .libraryBookPurchaseRequest,
             url: Url.libraryBookPurchaseRequest.string()),
        
        Menu(title: "[図書館常三島]開館カレンダー",
             type: .libraryCalendar,
             url: Url.libraryCalendarMain.string()),
        
        Menu(title: "[図書館蔵本]開館カレンダー",
             type: .libraryCalendarKura,
             url: Url.libraryCalendarKura.string()),
        
        Menu(title: "シラバス",
             type: .syllabus,
             url: Url.syllabus.string(),
             canInitView: true),
        
        Menu(title: "時間割",
             type: .timeTable,
             url: Url.timeTable.string()),
        
        Menu(title: "今年の成績表",
             type: .currentTermPerformance,
             url: Url.currentTermPerformance.string()),
        
        Menu(title: "成績参照",
             type: .termPerformance,
             url: Url.termPerformance.string()),
        
        Menu(title: "出欠記録",
             type: .presenceAbsenceRecord,
             url: Url.presenceAbsenceRecord.string()),
        
        Menu(title: "授業アンケート",
             type: .classQuestionnaire,
             url: Url.classQuestionnaire.string()),
        
        Menu(title: "メール",
             type: .mailService,
             url: Url.outlookLogin.string(),
             canInitView: true),
        
        Menu(title: "キャリア支援室",
             type: .tokudaiCareerCenter,
             url: Url.tokudaiCareerCenter.string(),
             canInitView: true),
        
        Menu(title: "履修登録",
             type: .courseRegistration,
             url: Url.courseRegistration.string()),
        
        Menu(title: "システムサービス一覧",
             type: .systemServiceList,
             url: Url.systemServiceList.string(),
             canInitView: true),
        
        Menu(title: "Eラーニング一覧",
             type: .eLearningList,
             url: Url.eLearningList.string(),
             canInitView: true),
        
        Menu(title: "大学サイト",
             type: .universityWeb,
             url: Url.universityHomePage.string(),
             canInitView: true)
    ]
    
    static let initSettingLists = [
        Menu(title: "並び替え・編集",
             type: .cellSort),
        
        Menu(title: "初期画面設定",
             type: .firstViewSetting),
        
        Menu(title: "パスワード",
             type: .password),
        
        Menu(title: "このアプリについて",
             type: .aboutThisApp)
    ]
    
    static let sectionNum = 2
}
