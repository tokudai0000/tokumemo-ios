//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation
import Kanna

final class MainViewModel {
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    
    public var subjectName = ""
    public var teacherName = ""
        
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
    public func isJudgeUrl(_ scene: Scene, isRegistrant: Bool = DataManager.singleton.isRegistrantCheck) -> Bool {
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
    
    public func getCurrentTermPerformance() -> URLRequest {
        let current = Calendar.current
        var year = current.component(.year, from: Date())
        let month = current.component(.month, from: Date())
        
        if (month <= 3){ // 1月から3月までは前年の成績であるから
            year -= 1
        }
        let termPerformanceYearURL = Url.currentTermPerformance.string() + String(year)
        if let url = URL(string: termPerformanceYearURL) {
            return URLRequest(url: url)
            
        } else {
            // エラー処理
            AKLog(level: .FATAL, message: "URLフォーマットエラー")
            fatalError() // 予期しないため、強制的にアプリを落とす
        }
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
