//
//  UrlModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation

/// 全てのURLはここに保存
/// UrlModel.login.string()でloginの文字列URLが
/// UrlModel.login.urlRequest()でloginのurlRequestフォーマットされたURLが取得可能
enum Url: String {
    case login                       // ログイン画面
    case universityHome              // 大学ホームページ
    case courceManagementHomeMobile  // 情報ポータル、ホーム画面URL
    case courceManagementHomePC      // 情報ポータル、ホーム画面URL
    case manabaHomeMobile            // マナバURL
    case manabaHomePC                // マナバURL
    case libraryHome                 // 図書館ホームページ
    case libraryLogin                // 図書館MyPageログイン
    case libraryBookLendingExtension // 図書館本貸出し期間延長URL
    case libraryBookPurchaseRequest  // 図書館本購入リクエスト
    case syllabusSearchMain
    case timeTable                   // 時間割
    case currentTermPerformance      // 今年の成績表
    case termPerformance             // 成績参照
    case presenceAbsenceRecord       // 出欠記録
    case classQuestionnaire          // 授業アンケート
    case systemServiceList           // システムサービス一覧
    case eLearningList               // Eラーニング一覧
    case outlookHome
    case tokudaiCareerCenter         // キャリアセンター
    case courseRegistration          // 履修登録URL
    case lostConnection
    case libraryCalendar             // 図書館カレンダー
    case syllabus
    case timeOut
    case enqueteReminder
    case popupToYoutube
    case mailService                 // MicroSoftのoutlookへ遷移
    case outlookLogin
    
    
    func string() -> String {
        return NSLocalizedString(self.rawValue, tableName: "url", comment: "")
    }
    
    /// 文字列URLをURLRequestへフォーマット
    func urlRequest() -> URLRequest {
        if let url = URL(string: self.string()) {
            return URLRequest(url: url)
            
        } else {
            AKLog(level: .FATAL, message: "URLフォーマットエラー")
            fatalError() // 予期しないため、強制的にアプリを落とす
        }
    }
}
