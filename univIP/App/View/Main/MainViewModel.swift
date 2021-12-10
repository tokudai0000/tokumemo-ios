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
    public func recordUrl(_ url: URL) {
        dataManager.forwardDisplayUrl = dataManager.displayUrl
        dataManager.displayUrl = url.absoluteString
        print("displayURL:\n \(url.absoluteString) \n")
    }
    
    /// 現在のURLが許可されたドメインか判定
    public func isAllowedDomeinCheck(_ urlString: String = DataManager.singleton.displayUrl) -> Bool {
        guard let url = URL(string: urlString),
              let host = url.host else {
                  AKLog(level: .ERROR, message: "URL(string)パース,ドメイン取得エラー")
                  return false
              }
        
        for allow in model.allowedDomains {
            if host.contains(allow){
                return true
            }
        }
        return false
    }
    
    enum DiscriminantType {
        case login
        case enqueteReminder
        case syllabus
        case outlook
        case tokudaiCareerCenter
        case timeOut
        case registrantAndLostConnectionDecision
    }
    /// 現在のURLがsceneかどうか判定
    public func isJudgeUrl(_ type: DiscriminantType,
                           isRegistrant: Bool = DataManager.singleton.canLogedInServiece,
                           forwardUrl: String = DataManager.singleton.forwardDisplayUrl,
                           displayUrl: String = DataManager.singleton.displayUrl) -> Bool {
        // MARK: - HACK
        var isLists:[Bool] = []
        
        switch type {
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
    
    public func searchInitialViewUrl() -> URLRequest {
        if dataManager.canLogedInServiece {
            let lists = dataManager.settingCellList
            for list in lists {
                if list.initialView {
                    if let url = URL(string: list.url) {
                        return URLRequest(url: url)
                    }
                }
            }
            return Url.manabaHomePC.urlRequest()
        }
        return Url.systemServiceList.urlRequest()
    }
}
