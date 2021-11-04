//
//  UrlModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation
// URLStringsとURLRequestの2つを返す必要ある


enum UrlModel: String {
    
    case login = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
    case courceManagementHomeSP = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx"
    case courceManagementHomePC = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx"
    case manabaSP = "https://manaba.lms.tokushima-u.ac.jp/s/home_summary"
    case manabaPC = "https://manaba.lms.tokushima-u.ac.jp/ct/home"
    case libraryLogin = "https://opac.lib.tokushima-u.ac.jp/opac/user/top"
    case libraryBookLendingExtension = "https://opac.lib.tokushima-u.ac.jp/opac/user/holding-borrowings"
    case libraryBookPurchaseRequest = "https://opac.lib.tokushima-u.ac.jp/opac/user/purchase_requests/new"
    case syllabusSearchMain = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx"
    case timeTable = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx"
    case currentTermPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year="
    case termPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx"
    case presenceAbsenceRecord = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"
    case classQuestionnaire = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx"
    case systemServiceList = "https://www.ait.tokushima-u.ac.jp/service/list_out/"
    case eLearningList = "https://uls01.ulc.tokushima-u.ac.jp/info/index.html"
    case outlookHome = "https://outlook.office.com/mail/"
    case tokudaiCareerCenter = "https://www.tokudai-syusyoku.com/index.php"
    case libraryHome = "https://www.lib.tokushima-u.ac.jp/"
    case courseRegistration = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistEdit.aspx"
    case lostConnection = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="
    case libraryCalendar = "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_"
    case syllabus = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"
    case timeOut = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"
    case enqueteReminder = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"
    case popupToYoutube = "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon"
    case mailService = "https://outlook.office365.com/tokushima-u.ac.jp"
    case outlookLogin = "https://wa.tokushima-u.ac.jp/adfs/ls"
    
    func string() -> String {
        switch self {
        case .login:                       return "https://eweb.stud.tokushima-u.ac.jp/Portal/"
        case .courceManagementHomeSP:      return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx"
        case .courceManagementHomePC:      return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx"
        case .manabaSP:                    return "https://manaba.lms.tokushima-u.ac.jp/s/home_summary"
        case .manabaPC:                    return "https://manaba.lms.tokushima-u.ac.jp/ct/home"
        case .libraryLogin:                return "https://opac.lib.tokushima-u.ac.jp/opac/user/top"
        case .libraryBookLendingExtension: return "https://opac.lib.tokushima-u.ac.jp/opac/user/holding-borrowings"
        case .libraryBookPurchaseRequest:  return "https://opac.lib.tokushima-u.ac.jp/opac/user/purchase_requests/new"
        case .syllabusSearchMain:          return "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx"
        case .timeTable:                   return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx"
        case .currentTermPerformance:      return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year="
        case .termPerformance:             return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx"
        case .presenceAbsenceRecord:       return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"
        case .classQuestionnaire:          return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx"
        case .systemServiceList:           return "https://www.ait.tokushima-u.ac.jp/service/list_out/"
        case .eLearningList:               return "https://uls01.ulc.tokushima-u.ac.jp/info/index.html"
        case .outlookHome:                 return "https://outlook.office.com/mail/"
        case .tokudaiCareerCenter:         return "https://www.tokudai-syusyoku.com/index.php"
        case .libraryHome:                 return "https://www.lib.tokushima-u.ac.jp/"
        case .courseRegistration:          return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistEdit.aspx"
        case .lostConnection:              return "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="
        case .libraryCalendar:             return "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_"
        case .syllabus:                    return "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"
        case .timeOut:                     return "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"
        case .enqueteReminder:             return "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"
        case .popupToYoutube:              return "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon"
        case .mailService:                 return "https://outlook.office365.com/tokushima-u.ac.jp"
        case .outlookLogin:                return "https://wa.tokushima-u.ac.jp/adfs/ls"
        }
    }
    
    
    func urlRequest() -> URLRequest {
        switch self {
        case .login:                       return format(UrlModel.login.string())
        case .courceManagementHomeSP:      return format(UrlModel.courceManagementHomeSP.string())
        case .courceManagementHomePC:      return format(UrlModel.courceManagementHomePC.string())
        case .manabaSP:                    return format(UrlModel.manabaSP.string())
        case .manabaPC:                    return format(UrlModel.manabaPC.string())
        case .libraryLogin:                return format(UrlModel.libraryLogin.string())
        case .libraryBookLendingExtension: return format(UrlModel.libraryBookLendingExtension.string())
        case .libraryBookPurchaseRequest:  return format(UrlModel.libraryBookPurchaseRequest.string())
        case .syllabusSearchMain:          return format(UrlModel.syllabus.string())
        case .timeTable:                   return format(UrlModel.timeTable.string())
        case .currentTermPerformance:      return format(UrlModel.currentTermPerformance.string())
        case .termPerformance:             return format(UrlModel.termPerformance.string())
        case .presenceAbsenceRecord:       return format(UrlModel.presenceAbsenceRecord.string())
        case .classQuestionnaire:          return format(UrlModel.classQuestionnaire.string())
        case .systemServiceList:           return format(UrlModel.systemServiceList.string())
        case .eLearningList:               return format(UrlModel.eLearningList.string())
        case .outlookHome:                 return format(UrlModel.outlookHome.string())
        case .tokudaiCareerCenter:         return format(UrlModel.tokudaiCareerCenter.string())
        case .libraryHome:                 return format(UrlModel.libraryHome.string())
        case .courseRegistration:          return format(UrlModel.courseRegistration.string())
        case .lostConnection:              return format(UrlModel.lostConnection.string())
        case .libraryCalendar:             return format(UrlModel.libraryCalendar.string())
        case .syllabus:                    return format(UrlModel.syllabus.string())
        case .timeOut:                     return format(UrlModel.timeOut.string())
        case .enqueteReminder:             return format(UrlModel.enqueteReminder.string())
        case .popupToYoutube:              return format(UrlModel.popupToYoutube.string())
        case .mailService:                 return format(UrlModel.mailService.string())
        case .outlookLogin:                return format(UrlModel.outlookLogin.string())
        }
    }

    
    public func format(_ urlString: String) -> URLRequest {

        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        
        } else {
            AKLog(level: .FATAL, message: "")
            fatalError()
    
        }
    }
    
}
