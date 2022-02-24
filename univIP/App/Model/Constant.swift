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
    static let latestTermsVersion = "1.0"
    
    // WebViewで読み込みを許可するドメイン
    static let allowedDomains = ["tokushima-u.ac.jp",    // 大学サイト
                                 "office365.com",        // outlook(メール) ログイン画面
                                 "microsoftonline.com",  // outlook(メール) ログイン画面表示前、1度だけ遷移されるその後"office365.com"へ遷移される
                                 "office.com",           // outlook(メール) メールボックス
                                 "tokudai-syusyoku.com", // キャリア支援室
                                 "tokudai.marucoop.com", // 徳島大学生活共同組合
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
        case libraryCalendar                // 図書館カレンダー
        case syllabus                       // シラバス
        case timeTable                      // 時間割
        case currentTermPerformance         // 今年の成績表
        case termPerformance                // 成績参照
        case presenceAbsenceRecord          // 出欠記録
        case classQuestionnaire             // 授業アンケート
        case mailService                    // メール
        case tokudaiCareerCenter            // キャリアセンター
        case tokudaiCoop                    // 徳島大学生活共同組合
        case courseRegistration             // 履修登録
        case systemServiceList              // システムサービス一覧
        case eLearningList                  // Eラーニング一覧
        case universityWeb                  // 大学サイト
        
        case cellSort                       // 並び替え
        case firstViewSetting               // 初期画面設定
        case password                       // パスワード
        case aboutThisApp                   // このアプリについて
        
        case favorite                       // お気に入り登録
    }
    
    struct Menu: Codable {
        var title: String             // 表示名ユーザーが変更することができる
        let id: MenuLists
        let url: String?
        var isDisplay: Bool = true    // 初期値は全てtrue(ユーザー「常三島生、蔵本生」によって表示内容を変更させる)
        var isInitView: Bool = false  // 初期値は「マナバPC版」のみtrue
        let canInitView: Bool         // 初期画面として設定可能か
    }
    
    // サービスCell初期状態（更新確認、初回利用者はここを確認される）
    static let initServiceLists = [
        
        Menu(title: "教務事務システム",
             id: .courseManagementHomeMobile,
             url: Url.courseManagementMobile.string(),
             canInitView: true),
        
        Menu(title: "マナバ",
             id: .manabaHomePC,
             url: Url.manabaPC.string(),
             isInitView: true,         // デフォルトの初期画面
             canInitView: true),
        
        Menu(title: "図書貸し出し延長",
             id: .libraryBookLendingExtension,
             url: Url.libraryBookLendingExtension.string(),
             canInitView: false),
        
        Menu(title: "開館カレンダー",
             id: .libraryCalendar,
             url: nil,
             canInitView: false),
        
        Menu(title: "生協営業状況",
             id: .tokudaiCoop,
             url: Url.tokudaiCoop.string(),
             canInitView: true),
        
        Menu(title: "シラバス",
             id: .syllabus,
             url: Url.syllabus.string(),
             canInitView: true),
        
        Menu(title: "今期の成績",
             id: .currentTermPerformance,
             url: Url.currentTermPerformance.string(),
             canInitView: false),
        
        Menu(title: "メール",
             id: .mailService,
             url: Url.outlookService.string(),
             canInitView: true),
        
        Menu(title: "パスワード",
             id: .password,
             url: nil,
             canInitView: false),
        
        Menu(title: "カスタマイズ",
             id: .cellSort,
             url: nil,
             canInitView: false),
        
        Menu(title: "初期画面設定",
             id: .firstViewSetting,
             url: nil,
             canInitView: false),
        
        Menu(title: "このアプリについて",
             id: .aboutThisApp,
             url: nil,
             canInitView: false),
        
        // 以下デフォルトでは表示させない
        
        Menu(title: "教務事務システム[PC]",
             id: .courseManagementHomePC,
             url: Url.courseManagementPC.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "マナバ[Mobile]",
             id: .manabaHomeMobile,
             url: Url.manabaMobile.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "図書Web[常三島]",
             id: .libraryWebHomePC,
             url: Url.libraryHomePageMainPC.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "図書Web[蔵本]",
             id: .libraryWebHomePC,
             url: Url.libraryHomePageKuraPC.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "図書Web[Mobile]",
             id: .libraryWebHomeMobile,
             url: Url.libraryHomeMobile.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "図書MyPage",
             id: .libraryMyPage,
             url: Url.libraryMyPage.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "図書本購入リクエスト",
             id: .libraryBookPurchaseRequest,
             url: Url.libraryBookPurchaseRequest.string(),
             isDisplay: false,
             canInitView: false),
        
        Menu(title: "時間割",
             id: .timeTable,
             url: Url.timeTable.string(),
             isDisplay: false,
             canInitView: false),
        
        Menu(title: "成績参照",
             id: .termPerformance,
             url: Url.termPerformance.string(),
             isDisplay: false,
             canInitView: false),
        
        Menu(title: "出欠記録",
             id: .presenceAbsenceRecord,
             url: Url.presenceAbsenceRecord.string(),
             isDisplay: false,
             canInitView: false),
        
        Menu(title: "授業アンケート",
             id: .classQuestionnaire,
             url: Url.classQuestionnaire.string(),
             isDisplay: false,
             canInitView: false),
        
        Menu(title: "キャリア支援室",
             id: .tokudaiCareerCenter,
             url: Url.tokudaiCareerCenter.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "システムサービス一覧",
             id: .systemServiceList,
             url: Url.systemServiceList.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "Eラーニング一覧",
             id: .eLearningList,
             url: Url.eLearningList.string(),
             isDisplay: false,
             canInitView: true),
        
        Menu(title: "大学サイト",
             id: .universityWeb,
             url: Url.universityHomePage.string(),
             isDisplay: false,
             canInitView: true)
    ]
    
}
