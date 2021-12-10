//
//  UrlModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation

/// login                                              :  ログイン画面
/// courceManagementHomeMobile  :  情報ポータル、ホーム画面URL
/// courceManagementHomePC       :  情報ポータル、ホーム画面URL
/// manabaHomeMobile                    :  マナバURL
/// manabaHomePC                         :  マナバURL
/// libraryLogin                                   : 図書館MyPage
/// libraryBookLendingExtension       : 図書館本貸出し期間延長
/// libraryBookPurchaseRequest       : 図書館本購入リクエスト
/// syllabusSearchMain                     : シラバス
/// timeTable                                      : 時間割
/// currentTermPerformance              : 今年の成績表
/// termPerformance                          : 成績参照
/// presenceAbsenceRecord             : 出欠記録
/// classQuestionnaire                       : 授業アンケート
/// systemServiceList                        : システムサービス一覧
/// eLearningList                                : Eラーニング一覧
/// outlookHome                                : メール
/// tokudaiCareerCenter                    : キャリアセンター
/// libraryHome                                  : 図書館Webサイト
/// courseRegistration                       : 履修登録
/// lostConnection                             : タイムアウトURL
/// libraryCalendar                            : 図書館カレンダー
/// syllabus                                       : シラバス
/// timeOut                                        : タイムアウトURL
/// enqueteReminder                        : 履修登録
/// popupToYoutube                          : マナバからYoutubeを開く場合表示されるポップアップのURL
/// mailService                                  : MicroSoftのoutlookへ遷移
/// outlookLogin                                : メール
/// universityHome                            : 大学ホームページ

/// 全てのURLはここに保存
/// Url.login.string()でloginの文字列URLが
/// Url.login.urlRequest()でloginのurlRequestフォーマットされたURLが取得可能
enum Url: String {
    case login
    case universityHome
    case courceManagementHomeMobile
    case courceManagementHomePC
    case manabaHomeMobile
    case manabaHomePC
    case libraryHomePC
    case libraryHomeMobile
    case libraryLogin
    case libraryBookLendingExtension
    case libraryBookPurchaseRequest
    case syllabusSearchMain
    case timeTable
    case currentTermPerformance
    case termPerformance
    case presenceAbsenceRecord
    case classQuestionnaire
    case systemServiceList
    case eLearningList
    case outlookHome
    case tokudaiCareerCenter
    case courseRegistration
    case lostConnection
    case libraryCalendar
    case syllabus
    case timeOut
    case enqueteReminder
    case popupToYoutube
    case mailService
    case outlookLogin
    
    /// URLを文字列として返す
    func string() -> String {
        // rowValueの値をurl.stringsから取ってくる
        return NSLocalizedString(rawValue, tableName: "url", comment: "")
    }
    
    /// URLをURLRequestとして返す
    func urlRequest() -> URLRequest {
        if let url = URL(string: self.string()) {
            return URLRequest(url: url)
            
        } else {
            // エラー処理
            AKLog(level: .FATAL, message: "URLフォーマットエラー")
            fatalError() // 予期しないため、強制的にアプリを落とす
        }
    }
}
