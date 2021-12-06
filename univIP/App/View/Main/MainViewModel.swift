//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

final class MainViewModel {
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    
    public var subjectName = ""
    public var teacherName = ""
    
    /// 前回のURLと現在表示しているURLの保持
    public func registUrl(_ url: URL) {
        
        dataManager.forwardDisplayUrl = dataManager.displayUrl
        dataManager.displayUrl = url.absoluteString
        
        print("displayURL:\n \(dataManager.displayUrl) \n")
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
    public func isJudgeUrl(_ scene: Scene,
                           isRegistrant: Bool = DataManager.singleton.isRegistrantCheck,
                           forwardUrl: String = DataManager.singleton.forwardDisplayUrl,
                           displayUrl: String = DataManager.singleton.displayUrl) -> Bool {
        
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
        return true
    }
    
}
