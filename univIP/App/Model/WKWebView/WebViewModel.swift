//
//  WebViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation
import Kanna
import Rswift

final class WebViewModel {
    
    static let singleton = WebViewModel() // シングルトン・インタンス
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    
    private var requestUrl: NSURLRequest?
    

    public var imageSystemName = ""
    public var animationView = ""
//    public var userCAccountMailAdress = ""
    public var reversePCtoSPIconName = "pcIcon"
    public var reversePCtoSPIsEnabled = false
    
    //  SyllabusViewの内容を渡され保存し、Webに入力する
    public var syllabusSubjectName = ""
    public var syllabusTeacherName = ""
    public var syllabusKeyword = ""
    public var syllabusSearchOnce = true
    
    
    // MARK: - Public
    
    /// 表示したいURLを返す
    public func url(_ menuTitle: SettingCellList) -> NSURLRequest? {
        
        // 登録、非登録による場合のURLを取得
        if let urlString = selectUrl(menuTitle, isLogedin: dataManager.isLoggedIn) {
            if let url = URL(string: urlString) {
                return NSURLRequest(url: url)
            }
        }
        AKLog(level: .ERROR, message: "error: URL取得エラー")
        return nil
    }

    /// 現在の
    public func isJudgeUrl(_ scene: Scene) -> Bool {
        let forwardUrl = dataManager.forwardDisplayUrl
        let displayUrl = dataManager.displayUrl
        var isLists:[Bool] = []
        
        switch scene {
        case .login:
            isLists.append(!forwardUrl.contains(UrlModel.lostConnection.string()))
            isLists.append(displayUrl.contains(UrlModel.lostConnection.string()))
            isLists.append(displayUrl.suffix(2)=="s1")
            isLists.append(isRegistrantCheck())
            
            
        case .enqueteReminder:
            isLists.append(!forwardUrl.contains(UrlModel.enqueteReminder.string()))
            isLists.append(displayUrl.contains(UrlModel.enqueteReminder.string()))
            
            
        case .syllabus:
            isLists.append(displayUrl.contains(UrlModel.syllabus.string()))
            isLists.append(syllabusSearchOnce)
            syllabusSearchOnce = false
            
            
        case .outlook:
            isLists.append(!forwardUrl.contains(UrlModel.outlookLogin.string()))
            isLists.append(displayUrl.contains(UrlModel.outlookLogin.string()))
            
            
        case .tokudaiCareerCenter:
            isLists.append(!forwardUrl.contains(UrlModel.tokudaiCareerCenter.string()))
            isLists.append(displayUrl == UrlModel.tokudaiCareerCenter.string())

                    
        case .timeOut:
            isLists.append(displayUrl == UrlModel.timeOut.string())
        
        
        case .registrantAndLostConnectionDecision:
            isLists.append(!isRegistrantCheck())
            isLists.append(displayUrl.contains(UrlModel.lostConnection.string()))
            
        }
        
        for isList in isLists {
            if !isList {
                return false
            }
        }
        if scene == .enqueteReminder {
            dataManager.isLoggedIn = true  // ログインできていることを保証
        }
        return true
    }
    
    /// 前回のURLと現在表示しているURLの保持
    public func registUrl(_ url: URL) {
        
        dataManager.forwardDisplayUrl = dataManager.displayUrl
        dataManager.displayUrl = url.absoluteString
        
        print("displayURL : \(dataManager.displayUrl)")
    }
    
    /// 現在のURLが許可されたドメインか判定
    public func isDomeinCheck(_ url: URL) -> Bool {
        
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
    
    /// 教務事務システムかマナバのモバイル版、PC版の判定
    public func judgeMobileOrPC() -> (ImageResource?, Bool) {
        
        let displayUrl = dataManager.displayUrl
        
        // モバイル版の時
        if displayUrl == UrlModel.courceManagementHomeMobile.string() ||
            displayUrl == UrlModel.manabaHomeMobile.string() {
            return (R.image.pcIcon, true)
            
            
        // PC版の時
        }else if displayUrl ==  UrlModel.courceManagementHomePC.string() ||
                    displayUrl == UrlModel.manabaHomePC.string() {
            return (R.image.spIcon, true)

            
        }else{
            return (nil, false)
            
        }
    }
    
    /// 登録者か判定
    public func isRegistrantCheck() -> Bool {
        if (DataManager.singleton.cAccount != "" &&
            DataManager.singleton.password != ""){
            return true

        }
        return false
        
    }
    
    public func CMAndManabaPCtoMB() -> URLRequest? {
        
        let displayUrl = dataManager.displayUrl
        
        if UserDefaults.standard.string(forKey: "CMPCtoSP") == "pc" {
            if displayUrl == UrlModel.courceManagementHomeMobile.string() {
                let response = url(.courseRegistration)
                if let url = response as URLRequest? {
                    return url

                }
            }
            
        } else {
//            return UrlModel.courceManagementHomePC.urlRequest()
            if displayUrl == UrlModel.courceManagementHomePC.string() {
                let response = url(.courceManagementHomeSP)
                if let url = response as URLRequest? {
                    return url

                }
            }
        }
        
        
        if UserDefaults.standard.string(forKey: "ManabaPCtoSP") == "pc"{
//            return UrlModel.manabaHomeMobile.urlRequest()
            if displayUrl == UrlModel.manabaHomeMobile.string() {
                let response = url(.manabaPC)
                if let url = response as URLRequest? {
                    return url

                }
            }
            
        } else {
//            return UrlModel.manabaHomePC.urlRequest()
            if displayUrl == UrlModel.manabaHomePC.string() {
                let response = url(.manabaSP)
                if let url = response as URLRequest? {
                    return url

                }
            }
        }
        return nil
        
    }
    
    
    
    // MARK: - Private
    
    private func selectUrl(_ menuTitle: SettingCellList, isLogedin: Bool) -> String?  {
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
    
    
    enum Scene {
        case login
        case enqueteReminder
        case syllabus
        case outlook
        case tokudaiCareerCenter
        case timeOut
        case registrantAndLostConnectionDecision
    }
    

    
    // シングルトン・インスタンスの初期処理
//    private init() {  //シングルトン保証// privateにすることにより他から初期化させない
//
//    }
    
}
