//
//  module.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

//import UIKit
enum Url: String {
    case login
    case maneg
    
    func string() -> String {
        switch self {
        case .login:
            return "https://eweb.stud.tokushima-u.ac.jp/Portal/"
        case .maneg:
            return "https://www.ait.tokushima-u.ac.jp/service/list_out/"
        }
    }
}

class Model {
    
    let urls = ["login" : // ログインURL
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/", topView: false),
                "courceManagementHomeSP" : // 情報ポータル、ホーム画面URL
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx", topView: true),
                "courceManagementHomePC" : // 情報ポータル、ホーム画面URL
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx", topView: true),
                "manabaSP" : // マナバURL
                    structURL(url: "https://manaba.lms.tokushima-u.ac.jp/s/home_summary", topView: true),
                "manabaPC" : // マナバURL
                    structURL(url: "https://manaba.lms.tokushima-u.ac.jp/ct/home", topView: true),
                "libraryLogin" : // 図書館URL
                    structURL(url: "https://opac.lib.tokushima-u.ac.jp/opac/user/top", topView: true),
                "libraryBookLendingExtension" : // 図書館本貸出し期間延長URL
                    structURL(url: "https://opac.lib.tokushima-u.ac.jp/opac/user/holding-borrowings", topView: true),
                "libraryBookPurchaseRequest" : // 図書館本購入リクエスト
                    structURL(url: "https://opac.lib.tokushima-u.ac.jp/opac/user/purchase_requests/new", topView: true),
                "syllabusSearchMain" : // シラバス検索URL
                    structURL(url: "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx", topView: true),
                "timeTable" : // 時間割
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx", topView: true),
                "currentTermPerformance" : // 今年の成績表
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year=", topView: true),
                "termPerformance" : // 成績参照
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx", topView: true),
                "presenceAbsenceRecord" : // 出欠記録
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx", topView: true),
                "classQuestionnaire" : // 授業アンケート
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx", topView: true),
                "systemServiceList" : // システムサービス一覧(非登録者に対して表示するURL)
                    structURL(url: "https://www.ait.tokushima-u.ac.jp/service/list_out/", topView: true),
                "eLearningList" : // Eラーニング一覧(非登録者に対して表示するURL)
                    structURL(url: "https://uls01.ulc.tokushima-u.ac.jp/info/index.html", topView: true),
                "outlookHome" : // outolookログインURLの一部
                    structURL(url: "https://outlook.office.com/mail/", topView: true),
                "tokudaiCareerCenter" : // キャリアセンター
                    structURL(url: "https://www.tokudai-syusyoku.com/index.php", topView: true),
                "libraryHome" : // 図書館ホームページ(非登録者に対して表示するURL)
                    structURL(url: "https://www.lib.tokushima-u.ac.jp/", topView: true),
                "courseRegistration" : // 履修登録URL
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistEdit.aspx", topView: true),
                "lostConnection" : // 接続切れの際、再リロード 83桁 =の後ろに付く(e1s1)は可変
                    structURL(url: "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=", topView: false),
                "libraryCalendar" : // 図書館カレンダー
                    structURL(url: "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_", topView: false),
                "syllabus" : // シラバスURL
                    structURL(url: "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/", topView: false),
                "timeOut" : // タイムアウト
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx", topView: false),
                "enqueteReminder" : // アンケート催促
                    structURL(url: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx", topView: false),
                "popupToYoutube" : // ポップアップ(Youtubeに遷移)
                    structURL(url: "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon", topView: false),
                "mailService" : // MicroSoftのoutlookへ遷移
                    structURL(url: "https://outlook.office365.com/tokushima-u.ac.jp", topView: false),
                "outlookLogin" : // outolookログインURLの一部
                    structURL(url: "https://wa.tokushima-u.ac.jp/adfs/ls", topView: false),]
    
    /// 許可するドメイン
    let allowDomains = ["tokushima-u.ac.jp",
                        "microsoftonline.com",
                        "office365.com",
                        "office.com",
                        "tokudai-syusyoku.com"]
    
        
    // 教務事務システム -> 個人向けメッセージ -> PDF開く際、 safariで
//    let transitionURLs = ["https://eweb.stud.tokushima-u.ac.jp/Portal/CommonControls/Message/MesFileDownload.aspx?param="]
    
    
    /// メール設定
    let mailMasterAddress = "tokumemo1@gmail.com"
    let mailSendTitle = "トクメモ開発者へ"
    let mailSendFailureText = "送信に失敗しました。失敗が続く場合は[tokumemo1@gmail.com]へ連絡をしてください。"
    
    var cellList:[CellList] = [CellList(id:0, name: "Webサイト", category: "図書館", display: true),
                               CellList(id:1, name: "貸し出し期間延長", category: "図書館", display: true),
                               CellList(id:2, name: "本購入リクエスト", category: "図書館", display: true),
                               CellList(id:3, name: "開館カレンダー", category: "図書館", display: true),
                               CellList(id:4, name: "シラバス", category: "シラバス", display: true),
                               CellList(id:5, name: "時間割", category: "教務事務システム", display: true),
                               CellList(id:6, name: "今年の成績表", category: "教務事務システム", display: true),
                               CellList(id:7, name: "成績参照", category: "教務事務システム", display: true),
                               CellList(id:8, name: "出欠記録", category: "教務事務システム", display: true),
                               CellList(id:9, name: "授業アンケート", category: "教務事務システム", display: true),
                               CellList(id:10, name: "メール", category: "Outlook", display: true),
                               CellList(id:11, name: "マナバPC版", category: "manaba", display: true),
                               CellList(id:12, name: "キャリア支援室", category: "就職活動", display: true),
                               CellList(id:13, name: "履修登録", category: "教務事務システム", display: true)]
    
    let agreementVersion = "aV_1"
}

struct structURL: Codable {
    let url: String
    let topView: Bool
}

struct CellList: Codable {
    let id: Int
    let name: String
    let category: String
    var display: Bool
}

