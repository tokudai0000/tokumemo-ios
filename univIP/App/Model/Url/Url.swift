//
//  UrlModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation

enum Url: String {
    
    case universityHomePage          // 大学ホームページ
    case systemServiceList           // システムサービス一覧
    case eLearningList               // Eラーニング一覧
    
    case courceManagementPC          // 教務事務システム(PC)
    case courceManagementMobile      // 教務事務システム(Mobile)
    case manabaPC                    // マナバ(PC)
    case manabaMobile                // マナバ(Mobile)
    
    case timeTable                   // 講義時間割
    case currentTermPerformance      // 今期の成績表
    case termPerformance             // 成績選択画面
    case presenceAbsenceRecord       // 出欠記録
    case classQuestionnaire          // 授業評価アンケート
    case courseRegistration          // 履修登録
    
    case libraryHomePageMainPC       // 図書館サイト(本館PC)
    case libraryHomePageKuraPC       // 図書館サイト(蔵本PC)
    case libraryHomeMobile           // 図書館サイト(Mobile)
    case libraryCalendarMain         // カレンダー(本館)
    case libraryCalendarKura         // カレンダー(蔵本)
    case libraryMyPage               // MyPage
    case libraryBookLendingExtension // 本貸出し期間延長
    case libraryBookPurchaseRequest  // 本購入リクエスト
    
    case outlookLogin                // outlook(メール)
    
    case syllabus                    // シラバス
    
    case tokudaiCareerCenter         // 徳島大学キャリアセンター
    
    case universityLogin             // 大学サイト、ログイン画面
    case universityServiceTimeOut    // タイムアウト(20分無操作)
    case enqueteReminder             // アンケート催促画面(教務事務表示前に出現)
    case popupToYoutube              // マナバから授業動画[Youtube]を開く時
    
    // URLを文字列として返す
    func string() -> String {
        // url.stringsからrowValueの値を返す
        return NSLocalizedString(rawValue, tableName: "url", comment: "")
    }
}
