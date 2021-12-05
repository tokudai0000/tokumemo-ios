//
//  WebViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation
import Kanna

final class WebViewModel {
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    
    public var subjectName = ""
    public var teacherName = ""
    
    // MARK: - Public
    
    /// 表示したいURLを返す
    public func url(_ menuTitle: SelectUrlList) -> URLRequest? {
        
        // 登録、非登録による場合のURLを取得
        if let urlString = selectUrl(menuTitle, isLogedin: dataManager.isRegistrantCheck) {
            if let url = URL(string: urlString) {
                return URLRequest(url: url)
            }
        }
        return nil
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
    
    enum Scene {
        case login
        case enqueteReminder
        case syllabus
        case outlook
        case tokudaiCareerCenter
        case timeOut
        case registrantAndLostConnectionDecision
    }
    
    /// 現在のURLがsceneかどうか判定
    public func isJudgeUrl(_ scene: Scene, isRegistrant: Bool) -> Bool {
        let forwardUrl = dataManager.forwardDisplayUrl
        let displayUrl = dataManager.displayUrl
        var isLists:[Bool] = []
        
        switch scene {
        case .login:
            isLists.append(!forwardUrl.contains(Url.lostConnection.string()))
            isLists.append(displayUrl.contains(Url.lostConnection.string()))
            isLists.append(displayUrl.suffix(2)=="s1")
            isLists.append(isRegistrant)
            
            
        case .enqueteReminder:
            isLists.append(!forwardUrl.contains(Url.enqueteReminder.string()))
            isLists.append(displayUrl.contains(Url.enqueteReminder.string()))
            
            
        case .syllabus:
            isLists.append(forwardUrl != Url.syllabus.string())
            isLists.append(displayUrl.contains(Url.syllabus.string()))
            
            
        case .outlook:
            isLists.append(!forwardUrl.contains(Url.outlookLogin.string()))
            isLists.append(displayUrl.contains(Url.outlookLogin.string()))
            
            
        case .tokudaiCareerCenter:
            isLists.append(!forwardUrl.contains(Url.tokudaiCareerCenter.string()))
            isLists.append(displayUrl == Url.tokudaiCareerCenter.string())
            
            
        case .timeOut:
            isLists.append(displayUrl == Url.timeOut.string())
            
            
        case .registrantAndLostConnectionDecision:
            isLists.append(!isRegistrant)
            isLists.append(displayUrl.contains(Url.lostConnection.string()))
            
        }
        
        for item in isLists {
            if !item {
                return false
            }
        }
        if scene == .enqueteReminder {
            dataManager.isLoggedIn = true  // ログインできていることを保証
        }
        return true
    }
    
    /// 教務事務システムかマナバのモバイル版、PC版の判定
    public func judgeMobileOrPC() -> String? {
        
        let displayUrl = dataManager.displayUrl
        
        // モバイル版の時
        if displayUrl == Url.courceManagementHomeMobile.string() ||
            displayUrl == Url.manabaHomeMobile.string() {
            return R.image.pcIcon.name
            
            
            // PC版の時
        } else if displayUrl ==  Url.courceManagementHomePC.string() ||
                    displayUrl == Url.manabaHomePC.string() {
            return R.image.mobileIcon.name
            
            
        } else {
            AKLog(level: .FATAL, message: "教務事務システムとマナバ以外")
            return nil
            
        }
    }
    
    /// 教務事務システム、マナバのMobileかPCか判定
    public func isCourceManagementOrManaba() -> Bool {
        
        switch dataManager.displayUrl {
            // 教務事務システムMobile版
        case Url.courceManagementHomeMobile.string():
            return true
            
            // 教務事務システムPC版
        case Url.courceManagementHomePC.string():
            return true
            
            // Manaba Mobile版
        case Url.manabaHomeMobile.string():
            return true
            
            // Manaba PC版
        case Url.manabaHomePC.string():
            return true
            
            
        default:
            return false
        }
    }
    
    
    // MARK: - Private
    
    enum SelectUrlList: String {
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
        case libraryHome
        case universityHome
    }
    
    private func selectUrl(_ menuTitle: SelectUrlList, isLogedin: Bool) -> String? {
        
        if isLogedin {
            
            switch menuTitle {
            case .login:                        return Url.login.string()
            case .courceManagementHomeSP:       return Url.courceManagementHomeMobile.string()
            case .courceManagementHomePC:       return Url.courceManagementHomePC.string()
            case .manabaSP:                     return Url.manabaHomeMobile.string()
            case .manabaPC:                     return Url.manabaHomePC.string()
            case .libraryLogin:                 return Url.libraryLogin.string()
            case .libraryBookLendingExtension:  return Url.libraryBookLendingExtension.string()
            case .libraryBookPurchaseRequest:   return Url.libraryBookPurchaseRequest.string()
            case .timeTable:                    return Url.timeTable.string()
            case .currentTermPerformance:       return getCurrentTermPerformance()
            case .termPerformance:              return Url.termPerformance.string()
            case .presenceAbsenceRecord:        return Url.presenceAbsenceRecord.string()
            case .classQuestionnaire:           return Url.classQuestionnaire.string()
            case .tokudaiCareerCenter:          return Url.tokudaiCareerCenter.string()
            case .courseRegistration:           return Url.courseRegistration.string()
            case .syllabus:                     return Url.syllabus.string()
            case .mailService:                  return Url.mailService.string()
            case .libraryCalendar:              return getLibraryCalender()
            case .systemServiceList:            return Url.systemServiceList.string()
            case .eLearningList:                return Url.eLearningList.string()
            case .libraryHome:                  return Url.libraryHome.string()
            case .universityHome:               return Url.universityHome.string()
            }
            
        } else {
            
            switch menuTitle {
            case .login:                        return Url.systemServiceList.string()
            case .courceManagementHomeSP:       return Url.systemServiceList.string()
            case .courceManagementHomePC:       return Url.systemServiceList.string()
            case .manabaSP:                     return Url.eLearningList.string()
            case .manabaPC:                     return Url.eLearningList.string()
            case .libraryLogin:                 return nil
            case .libraryBookLendingExtension:  return nil
            case .libraryBookPurchaseRequest:   return nil
            case .timeTable:                    return nil
            case .currentTermPerformance:       return nil
            case .termPerformance:              return nil
            case .presenceAbsenceRecord:        return nil
            case .classQuestionnaire:           return nil
            case .tokudaiCareerCenter:          return Url.tokudaiCareerCenter.string()
            case .courseRegistration:           return nil
            case .syllabus:                     return Url.syllabus.string()
            case .mailService:                  return Url.mailService.string()
            case .libraryCalendar:              return getLibraryCalender()
            case .systemServiceList:            return Url.systemServiceList.string()
            case .eLearningList:                return Url.eLearningList.string()
            case .libraryHome:                  return Url.libraryHome.string()
            case .universityHome:               return Url.universityHome.string()
            }
        }
    }
    
    private func getLibraryCalender() -> String? {
        let url = NSURL(string: Url.libraryHome.string())
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
        return Url.libraryCalendar.string()
    }
    
    private func getCurrentTermPerformance() -> String {
        let current = Calendar.current
        var year = current.component(.year, from: Date())
        let month = current.component(.month, from: Date())
        
        if (month <= 3){ // 1月から3月までは前年の成績であるから
            year -= 1
        }
        let termPerformanceYearURL = Url.currentTermPerformance.string() + String(year)
        return termPerformanceYearURL
    }
    
    public func getLibraryCalenderUrl() -> URLRequest? {
        let url = NSURL(string: Url.libraryHome.string())
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
                    if let url = URL(string: calenderURL) {
                        return URLRequest(url: url)
                        
                    } else {
                        // エラー処理
                        AKLog(level: .FATAL, message: "URLフォーマットエラー")
                        fatalError() // 予期しないため、強制的にアプリを落とす
                    }
                }
            }
            return nil
            
        } catch {
            return nil
        }
    }
    
}
