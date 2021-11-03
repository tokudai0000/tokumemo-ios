//
//  WebViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation
import Kanna

final class WebViewModel: NSObject {
    
    private let dataManager = DataManager()
    private let model = Model()
    private let urlModel = UrlModel()
    private var requestUrl: NSURLRequest?
    
    public var host = ""
    public var displayUrl = ""
    public var forwardDisplayUrl = ""
    
    public var imageSystemName = ""
    public var animationView = ""
    //  SyllabusViewの内容を渡され保存し、Webに入力する
    public var syllabusSubjectName = ""
    public var syllabusTeacherName = ""
    public var syllabusKeyword = ""
    public var syllabusSearchOnce = true
    
    public var cAccount = "c611821006"
    public var password = "q2KF2ZaxPtkL7Uu"
    public var mailAdress = ""
    public var passedCertification = false // ログインできていることを保証
    
    public var reversePCtoSPIconName = "pcIcon"
    public var reversePCtoSPIsEnabled = false
    
    
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
        
        if let urlString = selectUrl(menuTitle, isLogedin: passedCertification) {
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
    
    func registrantDecision() -> Bool{
        if (dataManager.cAccount == "" &&
                dataManager.passWord == ""){
            return false
            
        }else{
            return true
        }
    }
    
    public func openUrl(_ registrant: String, notRegistrant: String = "", isAlert: Bool = false) -> NSURLRequest? {
        //        webViewDisplay(bool: true)
        
        var notRegi = notRegistrant
        if notRegistrant == "" {
            notRegi = registrant
        }
        
        // 登録者判定
        if passedCertification {
            if let url = URL(string:registrant){
                return NSURLRequest(url: url)
                
            }
            
        } else {
            if let url = URL(string: notRegi){
                return NSURLRequest(url: url)
                
            }
            
//            if isAlert {
//                return nil
//            }
        }
        return nil
        
    }
    
    func isDomeinInspection(_ url: URL) -> Bool {
        guard let host = url.host else{
            AKLog(level: .ERROR, message: "ドメイン取得エラー")
            return false
        }
        var trigger = false
        for allow in model.allowDomains {
            if host.contains(allow){
                trigger = true
            }
        }
        return trigger
    }
    

    
    func judgeMobileOrPC() {
        
        if displayUrl == urlModel.courceManagementHomeSP ||
            displayUrl == urlModel.manabaSP {
            reversePCtoSPIconName = "pcIcon"
            reversePCtoSPIsEnabled = true
                        
        }else if displayUrl ==  urlModel.courceManagementHomePC ||
                    displayUrl == urlModel.manabaPC{
            reversePCtoSPIconName = "spIcon"
            reversePCtoSPIsEnabled = true

        }else{
            reversePCtoSPIsEnabled = false
            
        }
    }
    
    
    enum Scene {
        case login
        case enqueteReminder
        case syllabus
        case outlook
        case tokudaiCareerCenter
        case timeOut
        case registrantAndLostConnectionDecision
    }
    
    public func isJudgeUrl(_ scene: Scene) -> Bool {
        switch scene {
        case .login:
            let zero = !forwardDisplayUrl.contains(urlModel.lostConnection) // 前回のURLがログインURLではない = 初回
            let one = displayUrl.contains(urlModel.lostConnection)          // 今表示されているURLがログインURLか
            let second = displayUrl.suffix(2)=="s1"                         // 2回目は"=e1s2"　（zero があるが、安全策）
            let therd = registrantDecision()                                // 登録者判定
            if zero && one && second && therd {
                return true
            }
            return false
            
            
        case .enqueteReminder:
            let one = !forwardDisplayUrl.contains(urlModel.enqueteReminder)
            let second = displayUrl.contains(urlModel.enqueteReminder)
            if one && second {
                passedCertification = true  // ログインできていることを保証
                return true
            }
            return false
            
            
        case .syllabus:
            syllabusSearchOnce = false
            let one = displayUrl.contains(urlModel.syllabus)
            let second = syllabusSearchOnce
            if one && second {
                return true
            }
            return false
            
            
        case .outlook:
            let one = !forwardDisplayUrl.contains(urlModel.outlookLogin)
            let second = displayUrl.contains(urlModel.outlookLogin)
            if one && second {
                return true
            }
            return false
            
            
        case .tokudaiCareerCenter:
            let one = !forwardDisplayUrl.contains(urlModel.tokudaiCareerCenter)
            let second = displayUrl == urlModel.tokudaiCareerCenter
            if one && second {
                return true
            }
            return false
            
        
        case .timeOut:
            return displayUrl == urlModel.timeOut
        
        
        case .registrantAndLostConnectionDecision:
            return !registrantDecision() && displayUrl.contains(urlModel.lostConnection)
            
        }
    }
    
    
    public func registUrl(_ url: URL) {
        
        forwardDisplayUrl = displayUrl
        displayUrl = url.absoluteString
        
        print("displayURL : \(displayUrl)")
    }
    
    
    public func CMAndManabaPCtoMB() -> URLRequest? {
        if UserDefaults.standard.string(forKey: "CMPCtoSP") == "pc" {
            if displayUrl == urlModel.courceManagementHomeSP{
                let response = url(.courseRegistration)
                if let url = response as URLRequest? {
                    return url
                    
                }
            }
            
        } else {
            if displayUrl == urlModel.courceManagementHomePC {
                let response = url(.courceManagementHomeSP)
                if let url = response as URLRequest? {
                    return url
    
                }
            }
        }
        
        
        if UserDefaults.standard.string(forKey: "ManabaPCtoSP") == "pc"{
            if displayUrl == urlModel.manabaSP{
                let response = url(.manabaPC)
                if let url = response as URLRequest? {
                    return url
                    
                }
            }
            
        } else {
            if displayUrl == urlModel.manabaPC{
                let response = url(.manabaSP)
                if let url = response as URLRequest? {
                    return url
                    
                }
            }
        }
        return nil
        
    }
}
