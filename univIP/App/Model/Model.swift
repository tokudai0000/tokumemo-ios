//
//  module.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class Model: NSObject {
    /// ログインURL
    let loginURL = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
    
    /// 情報ポータル、ホーム画面URL
    let courceManagementHomeURL = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx"
    let courceManagementHomePCURL = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx"
    /// マナバURL
    let manabaURL = "https://manaba.lms.tokushima-u.ac.jp/s/home_summary"
    let manabaPCURL = "https://manaba.lms.tokushima-u.ac.jp/ct/home"
    /// 図書館URL
    let libraryLoginURL = "https://opac.lib.tokushima-u.ac.jp/opac/user/top"
    /// 図書館本貸出し期間延長URL
    let libraryBookLendingExtensionURL = "https://opac.lib.tokushima-u.ac.jp/opac/user/holding-borrowings"
    /// 図書館本購入リクエスト
    let libraryBookPurchaseRequestURL = "https://opac.lib.tokushima-u.ac.jp/opac/user/purchase_requests/new"
    /// 図書館カレンダー
    let libraryCalendar = "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_"
    /// シラバスURL
    let syllabusURL = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"
    
    /// シラバス検索URL
    let syllabusSearchMainURL = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx"
    /// 時間割
    let timeTableURL = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx"
    /// 今年の成績表
    let currentTermPerformanceURL = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year="
    /// 成績参照
    let termPerformanceURL = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx"
    /// 出欠記録
    let presenceAbsenceRecordURL = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"
    /// 授業アンケート
    let classQuestionnaire = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx"
    
    /// システムサービス一覧(非登録者に対して表示するURL)
    let systemServiceListURL = "https://www.ait.tokushima-u.ac.jp/service/list_out/"
    /// Eラーニング一覧(非登録者に対して表示するURL)
    let eLearningListURL = "https://uls01.ulc.tokushima-u.ac.jp/info/index.html"
    /// 図書館ホームページ(非登録者に対して表示するURL)
    let libraryHomeURL = "https://www.lib.tokushima-u.ac.jp/"
    
    /// 接続切れの際、再リロード 83桁 =の後ろに付く(e1s1)は可変
    let lostConnectionURL : String = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="
    /// タイムアウト
    let timeOutURL : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"
    /// アンケート催促
    let enqueteReminderURL : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"
    
    /// ポップアップ(Youtubeに遷移)
    let popupToYoutubeURL : String = "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon"
    
    /// MicroSoftのoutlookへ遷移
    let mailService = "https://outlook.office365.com/tokushima-u.ac.jp"
    
    /// outolookログインURLの一部
    let outlookLoginURL = "https://wa.tokushima-u.ac.jp/adfs/ls"
    
    let outlookHomeURL = "https://outlook.office.com/mail/"
    
    let tokudaiCareerCenterURL = "https://www.tokudai-syusyoku.com/index.php"
    
    /// 許可するドメイン
    let allowDomains = ["tokushima-u.ac.jp",
                        "microsoftonline.com",
                        "office365.com",
                        "office.com",
                        "tokudai-syusyoku.com"]
    
    /// トップ画面
//    let topMenuURLs = ["https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx",
//                       "https://manaba.lms.tokushima-u.ac.jp/s/home_summary",
//                       "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx",
//                       "https://opac.lib.tokushima-u.ac.jp/opac/user/top",
//                       "https://www.ait.tokushima-u.ac.jp/service/list_out/",
//                       "https://uls01.ulc.tokushima-u.ac.jp/info/index.html",
//                       "https://www.lib.tokushima-u.ac.jp/",
//                       "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=",
//                       "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"]
    
        
    // 教務事務システム -> 個人向けメッセージ -> PDF開く際、 safariで
    let transitionURLs = ["https://eweb.stud.tokushima-u.ac.jp/Portal/CommonControls/Message/MesFileDownload.aspx?param="]
    
    
    /// メール設定
    let mailMasterAddress = "tokumemo1@gmail.com"
    let mailSendTitle = "トクメモ開発者へ"
    let mailSendFailureText = "送信に失敗しました。失敗が続く場合は[tokumemo1@gmail.com]へ連絡をしてください。"
    
    var cellList:[CellList] = [CellList(name: "Webサイト", category: "図書館", display: true),
                               CellList(name: "貸し出し期間延長", category: "図書館", display: true),
                               CellList(name: "本購入リクエスト", category: "図書館", display: true),
                               CellList(name: "開館カレンダー", category: "図書館", display: true),
                               CellList(name: "シラバス", category: "シラバス", display: true),
                               CellList(name: "時間割", category: "教務事務システム", display: true),
                               CellList(name: "今年の成績表", category: "教務事務システム", display: true),
                               CellList(name: "成績参照", category: "教務事務システム", display: true),
                               CellList(name: "出欠記録", category: "教務事務システム", display: true),
                               CellList(name: "授業アンケート", category: "教務事務システム", display: true),
                               CellList(name: "メール", category: "Outlook", display: true),
                               CellList(name: "マナバPC版", category: "manaba", display: true),
                               CellList(name: "キャリア支援室", category: "就職活動", display: true),]
}

struct CellList: Codable {
    let name: String
    let category: String
    var display: Bool
    
//    init() {
//        name = ""
//        category   = ""
//        display = true
//    }
}

