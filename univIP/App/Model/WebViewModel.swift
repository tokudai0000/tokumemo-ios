//
//  WebViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation
import Kanna

final class WebViewModel: NSObject {
    
    let urlModel = UrlModel()
    
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
    }
    
    public func url(_ menuTitle: MenuTitle) -> NSURLRequest? {
        
        if let urlString = selectUrl(menuTitle, isLogedin: false) {
            if let url = URL(string: urlString) {
                return NSURLRequest(url: url)
            }
        }
        return nil
    }
    
    private func selectUrl(_ menuTitle: MenuTitle, isLogedin: Bool) -> String?  {
        if isLogedin {
            
            switch menuTitle {
            case .login:                        return urlModel.login
            case .courceManagementHomeSP:       return urlModel.courceManagementHomeSP
            case .courceManagementHomePC:       return urlModel.courceManagementHomePC
            case .manabaSP:                     return urlModel.manabaSP
            case .manabaPC:                     return urlModel.manabaPC
            case .libraryLogin:                 return urlModel.libraryLogin
            case .libraryBookLendingExtension:  return urlModel.libraryBookLendingExtension
            case .libraryBookPurchaseRequest:   return urlModel.libraryBookPurchaseRequest
            case .timeTable:                    return urlModel.timeTable
            case .currentTermPerformance:
                let current = Calendar.current
                var year = current.component(.year, from: Date())
                let month = current.component(.month, from: Date())
                
                if (month <= 3){ // 1月から3月までは前年の成績であるから
                    year -= 1
                }
                let termPerformanceYearURL = urlModel.currentTermPerformance + String(year)
                return termPerformanceYearURL
            case .termPerformance:              return urlModel.termPerformance
            case .presenceAbsenceRecord:        return urlModel.presenceAbsenceRecord
            case .classQuestionnaire:           return urlModel.classQuestionnaire
            case .tokudaiCareerCenter:          return urlModel.tokudaiCareerCenter
            case .courseRegistration:           return urlModel.courseRegistration
            case .syllabus:                     return urlModel.syllabus
            case .mailService:                  return urlModel.mailService
            case .libraryCalendar:
                let url = NSURL(string: urlModel.libraryHome)
                let data = NSData(contentsOf: url! as URL)
                
                var calenderURL = ""
                
                do {
                    let doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
                    for node in doc.xpath("//a") {
                        guard let str = node["href"] else {
                            return nil
                        }
                        if str.contains("pub/pdf/calender/calender_main_"){
                            calenderURL = "https://www.lib.tokushima-u.ac.jp/" + node["href"]!
                            return calenderURL
                        }
                    }
                    
                } catch {
                   return nil
                }
                return urlModel.libraryCalendar
            }
        } else {
            
            switch menuTitle {
            case .login:                        return urlModel.login
            case .courceManagementHomeSP:       return urlModel.systemServiceList
            case .courceManagementHomePC:       return urlModel.systemServiceList
            case .manabaSP:                     return urlModel.eLearningList
            case .manabaPC:                     return urlModel.eLearningList
            case .libraryLogin:                 return urlModel.libraryHome
            case .libraryBookLendingExtension:  return nil
            case .libraryBookPurchaseRequest:   return nil
            case .timeTable:                    return nil
            case .currentTermPerformance:       return nil
            case .termPerformance:              return nil
            case .presenceAbsenceRecord:        return nil
            case .classQuestionnaire:           return nil
            case .tokudaiCareerCenter:          return urlModel.tokudaiCareerCenter
            case .courseRegistration:           return nil
            case .syllabus:                     return urlModel.syllabus
            case .mailService:                  return urlModel.mailService
            case .libraryCalendar:
                let url = NSURL(string: urlModel.libraryHome)
                let data = NSData(contentsOf: url! as URL)
                
                var calenderURL = ""
                
                do {
                    let doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
                    for node in doc.xpath("//a") {
                        guard let str = node["href"] else {
                            return nil
                        }
                        if str.contains("pub/pdf/calender/calender_main_"){
                            calenderURL = "https://www.lib.tokushima-u.ac.jp/" + node["href"]!
                            return calenderURL
                        }
                    }
                    
                } catch {
                   return nil
                }
                return urlModel.libraryCalendar
            }
        }
    }
}
