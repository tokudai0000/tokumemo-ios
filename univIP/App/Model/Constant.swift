//
//  model.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import Foundation

final class Constant {
    
    // 利用規約バージョン
    static let agreementVersion = "1.0"
    
    // WebViewで読み込みを許可するドメイン
    static let allowedDomains = ["tokushima-u.ac.jp",    // 大学サイト
                                 "office365.com",        // outlook(メール) ログイン画面
                                 "microsoftonline.com",  // outlook(メール) ログイン画面表示前、1度だけ遷移されるその後"office365.com"へ遷移される
                                 "office.com",           // outlook(メール) メールボックス
                                 "tokudai-syusyoku.com", // キャリア支援室
                                 "youtube.com"]          // 大学サイトのインライン再生に対応させる為
    
    enum MenuLists: Codable {
        case courseManagementHomePC
        case courseManagementHomeMobile
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
        var title: String             // 表示名ユーザーが変更することができる
        let id: MenuLists
        let url: String?
        var isDisplay: Bool = false   // 初期値は全てfalse(ユーザー「常三島生、蔵本生」によって表示内容を変更させる)
        var isInitView: Bool = false  // 初期値は「マナバPC版」のみtrue
        let canInitView: Bool         // 初期画面として設定可能か
    }
    
    // サービスCell初期状態（更新確認、初回利用者はここを確認される）
    static let initServiceLists = [
        Menu(title: "教務事務システムPC版",
             id: .courseManagementHomePC,
             url: Url.courseManagementPC.string(),
             canInitView: true),
        
        Menu(title: "教務事務システムMobile版",
             id: .courseManagementHomeMobile,
             url: Url.courseManagementMobile.string(),
             canInitView: true),
        
        Menu(title: "マナバPC版",
             id: .manabaHomePC,
             url: Url.manabaPC.string(),
             isInitView: true,         // デフォルトの初期画面
             canInitView: true),
        
        Menu(title: "マナバMobile版",
             id: .manabaHomeMobile,
             url: Url.manabaMobile.string(),
             canInitView: true),
        
        Menu(title: "[図書館常三島]WebサイトPC版",
             id: .libraryWebHomePC,
             url: Url.libraryHomePageMainPC.string(),
             canInitView: true),
        
        Menu(title: "[図書館蔵本]WebサイトPC版",
             id: .libraryWebHomePC,
             url: Url.libraryHomePageMainPC.string(),
             canInitView: true),
        
        Menu(title: "[図書館常三島]WebサイトMobile版",
             id: .libraryWebHomeMobile,
             url: Url.libraryHomeMobile.string(),
             canInitView: true),
        
        Menu(title: "[図書館]MyPage",
             id: .libraryMyPage,
             url: Url.libraryMyPage.string(),
             canInitView: true),
        
        Menu(title: "[図書館]貸し出し期間延長",
             id: .libraryBookLendingExtension,
             url: Url.libraryBookLendingExtension.string(),
             canInitView: false),
        
        Menu(title: "[図書館]本購入リクエスト",
             id: .libraryBookPurchaseRequest,
             url: Url.libraryBookPurchaseRequest.string(),
             canInitView: false),
        
        Menu(title: "[図書館常三島]開館カレンダー",
             id: .libraryCalendar,
             url: Url.libraryCalendarMain.string(),
             canInitView: false),
        
        Menu(title: "[図書館蔵本]開館カレンダー",
             id: .libraryCalendarKura,
             url: Url.libraryCalendarKura.string(),
             canInitView: false),
        
        Menu(title: "シラバス",
             id: .syllabus,
             url: Url.syllabus.string(),
             canInitView: true),
        
        Menu(title: "時間割",
             id: .timeTable,
             url: Url.timeTable.string(),
             canInitView: false),
        
        Menu(title: "今年の成績表",
             id: .currentTermPerformance,
             url: Url.currentTermPerformance.string(),
             canInitView: false),
        
        Menu(title: "成績参照",
             id: .termPerformance,
             url: Url.termPerformance.string(),
             canInitView: false),
        
        Menu(title: "出欠記録",
             id: .presenceAbsenceRecord,
             url: Url.presenceAbsenceRecord.string(),
             canInitView: false),
        
        Menu(title: "授業アンケート",
             id: .classQuestionnaire,
             url: Url.classQuestionnaire.string(),
             canInitView: false),
        
        Menu(title: "メール",
             id: .mailService,
             url: Url.outlookLogin.string(),
             canInitView: true),
        
        Menu(title: "キャリア支援室",
             id: .tokudaiCareerCenter,
             url: Url.tokudaiCareerCenter.string(),
             canInitView: true),
        
        Menu(title: "履修登録",
             id: .courseRegistration,
             url: Url.courseRegistration.string(),
             canInitView: false),
        
        Menu(title: "システムサービス一覧",
             id: .systemServiceList,
             url: Url.systemServiceList.string(),
             canInitView: true),
        
        Menu(title: "Eラーニング一覧",
             id: .eLearningList,
             url: Url.eLearningList.string(),
             canInitView: true),
        
        Menu(title: "大学サイト",
             id: .universityWeb,
             url: Url.universityHomePage.string(),
             canInitView: true)
    ]
    
    static let initSettingLists = [
        Menu(title: "並び替え・編集",
             id: .cellSort,
             url: nil,
             canInitView: false),
        
        Menu(title: "初期画面設定",
             id: .firstViewSetting,
             url: nil,
             canInitView: false),
        
        Menu(title: "パスワード",
             id: .password,
             url: nil,
             canInitView: false),
        
        Menu(title: "このアプリについて",
             id: .aboutThisApp,
             url: nil,
             canInitView: false)
    ]
    
    static let sectionNum = 2
}
