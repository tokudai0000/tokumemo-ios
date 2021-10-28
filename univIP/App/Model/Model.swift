//
//  module.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import Foundation

class UrlModel {
//    public var isLogedin = false
    
    private let login = "https://eweb.stud.tokushima-u.ac.jp/Portal/"   //topView: false),
    private let courceManagementHomeSP = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx" // topView: true),
    private let courceManagementHomePC = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx" // topView: true),
    private let manabaSP = "https://manaba.lms.tokushima-u.ac.jp/s/home_summary" //topView: true),
    private let manabaPC = "https://manaba.lms.tokushima-u.ac.jp/ct/home" //topView: true),
    private let libraryLogin = "https://opac.lib.tokushima-u.ac.jp/opac/user/top" // topView: true),
    private let libraryBookLendingExtension = "https://opac.lib.tokushima-u.ac.jp/opac/user/holding-borrowings" // topView: true),
    private let libraryBookPurchaseRequest = "https://opac.lib.tokushima-u.ac.jp/opac/user/purchase_requests/new" // topView: true),
    private let syllabusSearchMain = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx"//, topView: true),
    private let timeTable = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx"//, topView: true),
    private let currentTermPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year="//, topView: true),
    private let termPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx"//, topView: true),
    private let presenceAbsenceRecord = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"//, topView: true),
    private let classQuestionnaire = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx"//, topView: true),
    private let systemServiceList = "https://www.ait.tokushima-u.ac.jp/service/list_out/"//, topView: true),
    private let eLearningList = "https://uls01.ulc.tokushima-u.ac.jp/info/index.html"//, topView: true),
    private let outlookHome = "https://outlook.office.com/mail/"//, topView: true),
    private let tokudaiCareerCenter = "https://www.tokudai-syusyoku.com/index.php"//, topView: true),
    private let libraryHome = "https://www.lib.tokushima-u.ac.jp/"//, topView: true),
    private let courseRegistration = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistEdit.aspx"//, topView: true),
    private let lostConnection = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="//, topView: false),
    private let libraryCalendar = "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_"//, topView: false),
    private let syllabus = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"//, topView: false),
    private let timeOut = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"//, topView: false),
    private let enqueteReminder = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"//, topView: false),
    private let popupToYoutube = "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon"//, topView: false),
    private let mailService = "https://outlook.office365.com/tokushima-u.ac.jp"//, topView: false),
    private let outlookLogin = "https://wa.tokushima-u.ac.jp/adfs/ls"//, topView: false),
    
    enum MenuTitle: String {
        case login
        case courceManagementHomeSP
        case courceManagementHomePC         // 情報ポータル、ホーム画面URL
        case manabaSP                       // マナバURL
        case manabaPC                       // マナバURL
        case libraryLogin                   // 図書館URL
        case libraryBookLendingExtension    // 図書館本貸出し期間延長URL
        case libraryBookPurchaseRequest     // 図書館本購入リクエスト
        case libraryCalendar                // 図書館カレンダー
        case syllabus                       // シラバスURL
        case timeTable                      // 時間割
        case currentTermPerformance         // 今年の成績表
        case termPerformance                // 成績参照
        case presenceAbsenceRecord          // 出欠記録
        case classQuestionnaire             // 授業アンケート
        case mailService                    // MicroSoftのoutlookへ遷移
        case tokudaiCareerCenter            // キャリアセンター
        case courseRegistration             // 履修登録URL
//        case libraryHome // 図書館ホームページ(非登録者に対して表示するURL)
//        case manabaSP // マナバURL
//        case manabaPC // マナバURL
//        case syllabusSearchMain // シラバス検索URL
//        case systemServiceList // システムサービス一覧(非登録者に対して表示するURL)
//        case eLearningList // Eラーニング一覧(非登録者に対して表示するURL)
//        case outlookHome // outolookログインURLの一部
//        case lostConnection // 接続切れの際、再リロード 83桁 =の後ろに付く(e1s1)は可変
//        case timeOut // タイムアウト
//        case enqueteReminder // アンケート催促
//        case popupToYoutube // ポップアップ(Youtubeに遷移)
//        case outlookLogin // outolookログインURLの一部
    }
    
    
    
    
//    var topView
    
    // 何のURLか、登録者か否か　出力はURL
    public func url(_ menuTitle: MenuTitle) -> (Bool, NSURLRequest?) {
        
        let response = selectUrl(menuTitle, isLogedin: false)
        
        if let urlString = response.1 {
            if let url = URL(string: urlString) {
                return (response.0, NSURLRequest(url: url))
            }
        }
        return (false, nil)
    }
    
    private func selectUrl(_ menuTitle: MenuTitle, isLogedin: Bool) -> (Bool, String?)  {
        if isLogedin {
            
            switch menuTitle {
            case .login:                        return (true, login)
            case .courceManagementHomeSP:       return (true, courceManagementHomeSP)
            case .courceManagementHomePC:       return (true, courceManagementHomePC)
            case .manabaSP:                     return (true, manabaSP)
            case .manabaPC:                     return (true, manabaPC)
            case .libraryLogin:                 return (true, libraryLogin)
            case .libraryBookLendingExtension:  return (true, libraryBookLendingExtension)
            case .libraryBookPurchaseRequest:   return (true, libraryBookPurchaseRequest)
            case .timeTable:                    return (true, timeTable)
            case .currentTermPerformance:       return (true, currentTermPerformance)
            case .termPerformance:              return (true, termPerformance)
            case .presenceAbsenceRecord:        return (true, presenceAbsenceRecord)
            case .classQuestionnaire:           return (true, classQuestionnaire)
            case .tokudaiCareerCenter:          return (true, tokudaiCareerCenter)
            case .courseRegistration:           return (true, courseRegistration)
            case .libraryCalendar:              return (true, libraryCalendar)
            case .syllabus:                     return (true, syllabus)
            case .mailService:                  return (true, mailService)
//            case .syllabusSearchMain:           return (true, syllabusSearchMain)
//            case .systemServiceList:            return (true, systemServiceList)
//            case .eLearningList:                return (true, eLearningList)
//            case .outlookHome:                  return (true, outlookHome)
//            case .libraryHome:                  return (true, libraryHome)
//            case .lostConnection:               return (true, lostConnection)
//            case .timeOut:                      return (true, timeOut)
//            case .enqueteReminder:              return (true, enqueteReminder)
//            case .popupToYoutube:               return (true, popupToYoutube)
//            case .outlookLogin:                 return (true, outlookLogin)
            }
        } else {
            
            switch menuTitle {
            case .login:                        return (true, login)
            case .courceManagementHomeSP:       return (true, nil)
            case .courceManagementHomePC:       return (true, nil)
            case .manabaSP:                     return (true, nil)
            case .manabaPC:                     return (true, nil)
            case .libraryLogin:                 return (true, libraryHome)
            case .libraryBookLendingExtension:  return (true, nil)
            case .libraryBookPurchaseRequest:   return (true, nil)
            case .timeTable:                    return (true, nil)
            case .currentTermPerformance:       return (true, nil)
            case .termPerformance:              return (true, nil)
            case .presenceAbsenceRecord:        return (true, nil)
            case .classQuestionnaire:           return (true, nil)
            case .tokudaiCareerCenter:          return (true, tokudaiCareerCenter)
            case .courseRegistration:           return (true, nil)
            case .libraryCalendar:              return (true, libraryCalendar)
            case .syllabus:                     return (true, syllabus)
            case .mailService:                  return (true, mailService)
            }
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


