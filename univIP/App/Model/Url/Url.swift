//
//  UrlModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation

enum Url: String {
    case login                            // ログイン画面
    case universityHome                   // 大学ホームページ
    case courceManagementHomeMobile       // 情報ポータル、ホーム画面
    case courceManagementHomePC
    case manabaHomeMobile                 // マナバ
    case manabaHomePC
    case libraryHomePC                    // 図書館Webサイト
    case libraryHomeKuraPC
    case libraryHomeMobile
    case libraryLogin                     // 図書館MyPage
    case libraryBookLendingExtension      // 図書館本貸出し期間延長
    case libraryBookPurchaseRequest
    case syllabusSearchMain               // シラバス
    case timeTable                        // 時間割
    case currentTermPerformance           // 今年の成績表
    case termPerformance                  // 成績参照
    case presenceAbsenceRecord
    case classQuestionnaire               // 授業アンケート
    case systemServiceList                // システムサービス一覧
    case eLearningList                    // Eラーニング一覧
    case outlookHome                      // メール
    case tokudaiCareerCenter              // キャリアセンター
    case courseRegistration               // 履修登録
    case lostConnection                   // タイムアウトURL
    case libraryCalendar                  // 図書館カレンダー
    case libraryCalendarKura              // 図書館カレンダー蔵本
    case syllabus                         // シラバス
    case timeOut                          // タイムアウト
    case enqueteReminder                  // 履修登録
    case popupToYoutube                   // マナバからYoutubeを開く場合表示されるポップアップのURL
    case mailService                      // MicroSoftのoutlookへ遷移
    case outlookLogin
    
    // URLを文字列として返す
    func string() -> String {
        // url.stringsからrowValueの値を返す
        return NSLocalizedString(rawValue, tableName: "url", comment: "")
    }
}
