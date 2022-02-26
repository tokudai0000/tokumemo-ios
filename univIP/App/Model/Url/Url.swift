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
    
    case courseManagementPC          // 教務事務システム(PC)
    case courseManagementMobile      // 教務事務システム(Mobile)
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
    
    case outlookService              // outlook(メール) 複数回遷移したのち、outlookLoginFormへ行く
    case outlookLoginForm            // ログイン画面
    
    case syllabus                    // シラバス
    
    case tokudaiCareerCenter         // 徳島大学キャリアセンター
    
    case tokudaiCoop                 // 徳島大学生活共同組合
    
    case universityTransitionLogin   // ログイン画面に遷移する為のURL(何度もURL遷移を行う)
    case universityLogin             // 大学サイト、ログイン画面
    case universityServiceTimeOut    // タイムアウト(20分無操作)
    case universityServiceTimeOut2   // タイムアウト2(20分無操作)
    case enqueteReminder             // アンケート催促画面(教務事務表示前に出現)
    case popupToYoutube              // マナバから授業動画[Youtube]を開く時
    
    // URLを文字列として返す
    func string() -> String {
        // url.stringsからrowValueの値を返す
        return NSLocalizedString(rawValue, tableName: "url", comment: "")
    }
    
    // URLをURLRequestとして返す
    func urlRequest() -> URLRequest {
        // url.stringsからrowValueの値を返す
        let urlString = NSLocalizedString(rawValue, tableName: "url", comment: "")
        let url = URL(string: urlString)! // fatalError
        return URLRequest(url: url)
    }
}
