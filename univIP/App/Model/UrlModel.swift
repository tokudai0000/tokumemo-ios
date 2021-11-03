//
//  UrlModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation

final class UrlModel {
    
    let login = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
    let courceManagementHomeSP = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx"
    let courceManagementHomePC = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx"
    let manabaSP = "https://manaba.lms.tokushima-u.ac.jp/s/home_summary"
    let manabaPC = "https://manaba.lms.tokushima-u.ac.jp/ct/home"
    let libraryLogin = "https://opac.lib.tokushima-u.ac.jp/opac/user/top"
    let libraryBookLendingExtension = "https://opac.lib.tokushima-u.ac.jp/opac/user/holding-borrowings"
    let libraryBookPurchaseRequest = "https://opac.lib.tokushima-u.ac.jp/opac/user/purchase_requests/new"
    let syllabusSearchMain = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx"
    let timeTable = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx"
    let currentTermPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year="
    let termPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx"
    let presenceAbsenceRecord = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"
    let classQuestionnaire = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx"
    let systemServiceList = "https://www.ait.tokushima-u.ac.jp/service/list_out/"
    let eLearningList = "https://uls01.ulc.tokushima-u.ac.jp/info/index.html"
    let outlookHome = "https://outlook.office.com/mail/"
    let tokudaiCareerCenter = "https://www.tokudai-syusyoku.com/index.php"
    let libraryHome = "https://www.lib.tokushima-u.ac.jp/"
    let courseRegistration = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistEdit.aspx"
    let lostConnection = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="
    let libraryCalendar = "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_"
    let syllabus = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"
    let timeOut = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"
    let enqueteReminder = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"
    let popupToYoutube = "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon"
    let mailService = "https://outlook.office365.com/tokushima-u.ac.jp"
    let outlookLogin = "https://wa.tokushima-u.ac.jp/adfs/ls"
    
//    enum MenuTitle: String {
//        case login
//        case courceManagementHomeSP
//        case courceManagementHomePC         // 情報ポータル、ホーム画面URL
//        case manabaSP                       // マナバURL
//        case manabaPC                       // マナバURL
//        case libraryLogin                   // 図書館URL
//        case libraryBookLendingExtension    // 図書館本貸出し期間延長URL
//        case libraryBookPurchaseRequest     // 図書館本購入リクエスト
//        case libraryCalendar                // 図書館カレンダー
//        case syllabus                       // シラバスURL
//        case timeTable                      // 時間割
//        case currentTermPerformance         // 今年の成績表
//        case termPerformance                // 成績参照
//        case presenceAbsenceRecord          // 出欠記録
//        case classQuestionnaire             // 授業アンケート
//        case mailService                    // MicroSoftのoutlookへ遷移
//        case tokudaiCareerCenter            // キャリアセンター
//        case courseRegistration             // 履修登録URL
////        case libraryHome // 図書館ホームページ(非登録者に対して表示するURL)
////        case manabaSP // マナバURL
////        case manabaPC // マナバURL
////        case syllabusSearchMain // シラバス検索URL
////        case systemServiceList // システムサービス一覧(非登録者に対して表示するURL)
////        case eLearningList // Eラーニング一覧(非登録者に対して表示するURL)
////        case outlookHome // outolookログインURLの一部
////        case lostConnection // 接続切れの際、再リロード 83桁 =の後ろに付く(e1s1)は可変
////        case timeOut // タイムアウト
////        case enqueteReminder // アンケート催促
////        case popupToYoutube // ポップアップ(Youtubeに遷移)
////        case outlookLogin // outolookログインURLの一部
////        func url() -> String {
////            switch self {
////            case .login: return login
////            case .courceManagementHomeSP: return
////            case .Large:
////                return "Large"
////            case .Original:
////                return "Original"
////            }
////        }
//    }
//
//    enum Url : String {
//        case login : return login
//        case courceManagementHomeSP return courceManagementHomeSP
//        case courceManagementHomePC         // 情報ポータル、ホーム画面URL
//        case manabaSP                       // マナバURL
//        case manabaPC                       // マナバURL
//        case libraryLogin                   // 図書館URL
//        case libraryBookLendingExtension    // 図書館本貸出し期間延長URL
//        case libraryBookPurchaseRequest     // 図書館本購入リクエスト
//        case libraryCalendar                // 図書館カレンダー
//        case syllabus                       // シラバスURL
//        case timeTable                      // 時間割
//        case currentTermPerformance         // 今年の成績表
//        case termPerformance                // 成績参照
//        case presenceAbsenceRecord          // 出欠記録
//        case classQuestionnaire             // 授業アンケート
//        case mailService                    // MicroSoftのoutlookへ遷移
//        case tokudaiCareerCenter            // キャリアセンター
//        case courseRegistration             // 履修登録URL
////        case libraryHome // 図書館ホームページ(非登録者に対して表示するURL)
////        case manabaSP // マナバURL
////        case manabaPC // マナバURL
////        case syllabusSearchMain // シラバス検索URL
////        case systemServiceList // システムサービス一覧(非登録者に対して表示するURL)
////        case eLearningList // Eラーニング一覧(非登録者に対して表示するURL)
////        case outlookHome // outolookログインURLの一部
////        case lostConnection // 接続切れの際、再リロード 83桁 =の後ろに付く(e1s1)は可変
////        case timeOut // タイムアウト
////        case enqueteReminder // アンケート催促
////        case popupToYoutube // ポップアップ(Youtubeに遷移)
////        case outlookLogin // outolookログインURLの一部
//    }
    
    
    
    
//    var topView
    
    // 何のURLか、登録者か否か　出力はURL
//    public func url(_ menuTitle: MenuTitle) -> (Bool, NSURLRequest?) {
//
//        let response = selectUrl(menuTitle, isLogedin: )
//
//        if let urlString = response.1 {
//            if let url = URL(string: urlString) {
//                return (response.0, NSURLRequest(url: url))
//            }
//        }
//        return (false, nil)
//    }
//
//    private func selectUrl(_ menuTitle: MenuTitle, isLogedin: Bool) -> (Bool, String?)  {
//        if isLogedin {
//
//            switch menuTitle {
//            case .login:                        return (true, login)
//            case .courceManagementHomeSP:       return (true, courceManagementHomeSP)
//            case .courceManagementHomePC:       return (true, courceManagementHomePC)
//            case .manabaSP:                     return (true, manabaSP)
//            case .manabaPC:                     return (true, manabaPC)
//            case .libraryLogin:                 return (true, libraryLogin)
//            case .libraryBookLendingExtension:  return (true, libraryBookLendingExtension)
//            case .libraryBookPurchaseRequest:   return (true, libraryBookPurchaseRequest)
//            case .timeTable:                    return (true, timeTable)
//            case .currentTermPerformance:
//                let current = Calendar.current
//                var year = current.component(.year, from: Date())
//                let month = current.component(.month, from: Date())
//
//                if (month <= 3){ // 1月から3月までは前年の成績であるから
//                    year -= 1
//                }
//                let termPerformanceYearURL = currentTermPerformance + String(year)
//                return (true, termPerformanceYearURL)
//            case .termPerformance:              return (true, termPerformance)
//            case .presenceAbsenceRecord:        return (true, presenceAbsenceRecord)
//            case .classQuestionnaire:           return (true, classQuestionnaire)
//            case .tokudaiCareerCenter:          return (true, tokudaiCareerCenter)
//            case .courseRegistration:           return (true, courseRegistration)
//            case .syllabus:                     return (true, syllabus)
//            case .mailService:                  return (true, mailService)
//            case .libraryCalendar:
//                let url = NSURL(string: libraryHome)
//                let data = NSData(contentsOf: url! as URL)
//
//                var calenderURL = ""
//
//                do {
//                    let doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
//                    for node in doc.xpath("//a") {
//                        guard let str = node["href"] else {
//                            return (true, nil)
//                        }
//                        if str.contains("pub/pdf/calender/calender_main_"){
//                            calenderURL = "https://www.lib.tokushima-u.ac.jp/" + node["href"]!
//                            return (true, calenderURL)
//                        }
//                    }
//
//                } catch {
//                   return (true, nil)
//                }
//                return (true, libraryCalendar)
////            case .syllabusSearchMain:           return (true, syllabusSearchMain)
////            case .systemServiceList:            return (true, systemServiceList)
////            case .eLearningList:                return (true, eLearningList)
////            case .outlookHome:                  return (true, outlookHome)
////            case .libraryHome:                  return (true, libraryHome)
////            case .lostConnection:               return (true, lostConnection)
////            case .timeOut:                      return (true, timeOut)
////            case .enqueteReminder:              return (true, enqueteReminder)
////            case .popupToYoutube:               return (true, popupToYoutube)
////            case .outlookLogin:                 return (true, outlookLogin)
//            }
//        } else {
//
//            switch menuTitle {
//            case .login:                        return (true, login)
//            case .courceManagementHomeSP:       return (true, systemServiceList)
//            case .courceManagementHomePC:       return (true, systemServiceList)
//            case .manabaSP:                     return (true, eLearningList)
//            case .manabaPC:                     return (true, eLearningList)
//            case .libraryLogin:                 return (true, libraryHome)
//            case .libraryBookLendingExtension:  return (true, nil)
//            case .libraryBookPurchaseRequest:   return (true, nil)
//            case .timeTable:                    return (true, nil)
//            case .currentTermPerformance:       return (true, nil)
//            case .termPerformance:              return (true, nil)
//            case .presenceAbsenceRecord:        return (true, nil)
//            case .classQuestionnaire:           return (true, nil)
//            case .tokudaiCareerCenter:          return (true, tokudaiCareerCenter)
//            case .courseRegistration:           return (true, nil)
//            case .syllabus:                     return (true, syllabus)
//            case .mailService:                  return (true, mailService)
//            case .libraryCalendar:
//                let url = NSURL(string: libraryHome)
//                let data = NSData(contentsOf: url! as URL)
//
//                var calenderURL = ""
//
//                do {
//                    let doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
//                    for node in doc.xpath("//a") {
//                        guard let str = node["href"] else {
//                            return (true, nil)
//                        }
//                        if str.contains("pub/pdf/calender/calender_main_"){
//                            calenderURL = "https://www.lib.tokushima-u.ac.jp/" + node["href"]!
//                            return (true, calenderURL)
//                        }
//                    }
//
//                } catch {
//                   return (true, nil)
//                }
//                return (true, libraryCalendar)
//            }
//        }
//    }
    
}
