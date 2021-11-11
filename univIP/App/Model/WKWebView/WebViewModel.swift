//
//  WebViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation
import Kanna

final class WebViewModel {
    
    static let singleton = WebViewModel() // シングルトン・インタンス
    
    private let model = Model()
    private var requestUrl: NSURLRequest?
    
//    public var host = ""
    public var forwardDisplayUrl = ""    // 1つ前のURL
    public var displayUrl = ""           // 現在表示しているURL

    
    public var imageSystemName = ""
    public var animationView = ""
    public var userCAccountMailAdress = ""
    public var reversePCtoSPIconName = "pcIcon"
    public var reversePCtoSPIsEnabled = false
    
    //  SyllabusViewの内容を渡され保存し、Webに入力する
    public var syllabusSubjectName = ""
    public var syllabusTeacherName = ""
    public var syllabusKeyword = ""
    public var syllabusSearchOnce = true
    
    
    enum SettingMenuTitle: String {
        case login                          // ログイン画面
        case courceManagementHomeSP         // 情報ポータル、ホーム画面URL
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
        case systemServiceList              // システムサービス一覧
        case eLearningList                  // Eラーニング一覧
    }
    
    
    public func url(_ menuTitle: SettingMenuTitle) -> NSURLRequest? {

        if let urlString = selectUrl(menuTitle, isLogedin: DataManager.singleton.passedCertification) {
            if let url = URL(string: urlString) {
                return NSURLRequest(url: url)
            }
        }
        return nil
    }
    
    private func selectUrl(_ menuTitle: SettingMenuTitle, isLogedin: Bool) -> String?  {
        if isLogedin {
            
            switch menuTitle {
            case .login:                        return UrlModel.login.string()
            case .courceManagementHomeSP:       return UrlModel.courceManagementHomeMobile.string()
            case .courceManagementHomePC:       return UrlModel.courceManagementHomePC.string()
            case .manabaSP:                     return UrlModel.manabaHomeMobile.string()
            case .manabaPC:                     return UrlModel.manabaHomePC.string()
            case .libraryLogin:                 return UrlModel.libraryLogin.string()
            case .libraryBookLendingExtension:  return UrlModel.libraryBookLendingExtension.string()
            case .libraryBookPurchaseRequest:   return UrlModel.libraryBookPurchaseRequest.string()
            case .timeTable:                    return UrlModel.timeTable.string()
            case .currentTermPerformance:
                let current = Calendar.current
                var year = current.component(.year, from: Date())
                let month = current.component(.month, from: Date())
                
                if (month <= 3){ // 1月から3月までは前年の成績であるから
                    year -= 1
                }
                let termPerformanceYearURL = UrlModel.currentTermPerformance.string() + String(year)
                return termPerformanceYearURL
            case .termPerformance:              return UrlModel.termPerformance.string()
            case .presenceAbsenceRecord:        return UrlModel.presenceAbsenceRecord.string()
            case .classQuestionnaire:           return UrlModel.classQuestionnaire.string()
            case .tokudaiCareerCenter:          return UrlModel.tokudaiCareerCenter.string()
            case .courseRegistration:           return UrlModel.courseRegistration.string()
            case .syllabus:                     return UrlModel.syllabus.string()
            case .mailService:                  return UrlModel.mailService.string()
            case .libraryCalendar:
                let url = NSURL(string: UrlModel.libraryHome.string())
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
                return UrlModel.libraryCalendar.string()
            case .systemServiceList:            return UrlModel.systemServiceList.string()
            case .eLearningList:                return UrlModel.eLearningList.string()
            }
        } else {
            
            switch menuTitle {
            case .login:                        return UrlModel.login.string()
            case .courceManagementHomeSP:       return UrlModel.systemServiceList.string()
            case .courceManagementHomePC:       return UrlModel.systemServiceList.string()
            case .manabaSP:                     return UrlModel.eLearningList.string()
            case .manabaPC:                     return UrlModel.eLearningList.string()
            case .libraryLogin:                 return UrlModel.libraryHome.string()
            case .libraryBookLendingExtension:  return nil
            case .libraryBookPurchaseRequest:   return nil
            case .timeTable:                    return nil
            case .currentTermPerformance:       return nil
            case .termPerformance:              return nil
            case .presenceAbsenceRecord:        return nil
            case .classQuestionnaire:           return nil
            case .tokudaiCareerCenter:          return UrlModel.tokudaiCareerCenter.string()
            case .courseRegistration:           return nil
            case .syllabus:                     return UrlModel.syllabus.string()
            case .mailService:                  return UrlModel.mailService.string()
            case .libraryCalendar:
                let url = NSURL(string: UrlModel.libraryHome.string())
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
                return UrlModel.libraryCalendar.string()
            case .systemServiceList:            return UrlModel.systemServiceList.string()
            case .eLearningList:                return UrlModel.eLearningList.string()
            }
        }
    }
    
    func registrantDecision() -> Bool{
        if (DataManager.singleton.cAccount == "" &&
            DataManager.singleton.password == ""){
            return false
            
        }else{
            return true
        }
    }
    
    public func openUrl(_ registrant: String, notRegistrant: String = "", isAlert: Bool = false) -> NSURLRequest? {
        
        var notRegi = notRegistrant
        if notRegistrant == "" {
            notRegi = registrant
        }
        
        // 登録者判定
        if DataManager.singleton.passedCertification {
            if let url = URL(string:registrant){
                return NSURLRequest(url: url)
                
            }
            
        } else {
            if let url = URL(string: notRegi){
                return NSURLRequest(url: url)
                
            }
            
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
        
        if displayUrl == UrlModel.courceManagementHomeMobile.string() ||
            displayUrl == UrlModel.manabaHomeMobile.string() {
            reversePCtoSPIconName = "pcIcon"
            reversePCtoSPIsEnabled = true
                        
        }else if displayUrl ==  UrlModel.courceManagementHomePC.string() ||
                    displayUrl == UrlModel.manabaHomePC.string() {
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
            let zero = !forwardDisplayUrl.contains(UrlModel.lostConnection.string()) // 前回のURLがログインURLではない = 初回
            let one = displayUrl.contains(UrlModel.lostConnection.string())          // 今表示されているURLがログインURLか
            let second = displayUrl.suffix(2)=="s1"                         // 2回目は"=e1s2"　（zero があるが、安全策）
            let therd = registrantDecision()                                // 登録者判定
            if zero && one && second && therd {
                return true
            }
            return false
            
            
        case .enqueteReminder:
            let one = !forwardDisplayUrl.contains(UrlModel.enqueteReminder.string())
            let second = displayUrl.contains(UrlModel.enqueteReminder.string())
            if one && second {
                DataManager.singleton.passedCertification = true  // ログインできていることを保証
                return true
            }
            return false
            
            
        case .syllabus:
            syllabusSearchOnce = false
            let one = displayUrl.contains(UrlModel.syllabus.string())
            let second = syllabusSearchOnce
            if one && second {
                return true
            }
            return false
            
            
        case .outlook:
            let one = !forwardDisplayUrl.contains(UrlModel.outlookLogin.string())
            let second = displayUrl.contains(UrlModel.outlookLogin.string())
            if one && second {
                return true
            }
            return false
            
            
        case .tokudaiCareerCenter:
            let one = !forwardDisplayUrl.contains(UrlModel.tokudaiCareerCenter.string())
            let second = displayUrl == UrlModel.tokudaiCareerCenter.string()
            if one && second {
                return true
            }
            return false
            
        
        case .timeOut:
            return displayUrl == UrlModel.timeOut.string()
        
        
        case .registrantAndLostConnectionDecision:
            return !registrantDecision() && displayUrl.contains(UrlModel.lostConnection.string())
            
        }
    }
    
    
    public func registUrl(_ url: URL) {
        
        forwardDisplayUrl = displayUrl
        displayUrl = url.absoluteString
        
        print("displayURL : \(displayUrl)")
    }
    
    
    public func CMAndManabaPCtoMB() -> URLRequest? {
        if UserDefaults.standard.string(forKey: "CMPCtoSP") == "pc" {
            return UrlModel.courceManagementHomeMobile.urlRequest()
//            if displayUrl == UrlModel.courceManagementHomeSP.string() {
//                let response = url(.courseRegistration)
//                if let url = response as URLRequest? {
//                    return url
//
//                }
//            }
            
        } else {
            return UrlModel.courceManagementHomePC.urlRequest()
//            if displayUrl == UrlModel.courceManagementHomePC.string() {
//                let response = url(.courceManagementHomeSP)
//                if let url = response as URLRequest? {
//                    return url
//
//                }
//            }
        }
        
        
        if UserDefaults.standard.string(forKey: "ManabaPCtoSP") == "pc"{
            return UrlModel.manabaHomeMobile.urlRequest()
//            if displayUrl == UrlModel.manabaSP.string() {
//                let response = url(.manabaPC)
//                if let url = response as URLRequest? {
//                    return url
//
//                }
//            }
            
        } else {
            return UrlModel.manabaHomePC.urlRequest()
//            if displayUrl == UrlModel.manabaPC.string() {
//                let response = url(.manabaSP)
//                if let url = response as URLRequest? {
//                    return url
//
//                }
//            }
        }
        return nil
        
    }
    
    // シングルトン・インスタンスの初期処理
//    private init() {  //シングルトン保証// privateにすることにより他から初期化させない
//
//    }
    
}
