//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

final class MainViewModel {
    
    private let dataManager = DataManager.singleton
    
    public var subjectName = ""
    public var teacherName = ""
    
    /// 現在読み込み中のURL(displayUrl)が許可されたドメインかどうか
    /// - Returns: 許可されているドメイン名ならtrueを返す
    public func isAllowedDomeinCheck() -> Bool {
        
        guard let url = URL(string: dataManager.displayUrl),
              let hostDomain = url.host else { fatalError() }
        
        for allowedUrl in Constant.allowedDomains {
            if hostDomain.contains(allowedUrl) { return true }
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
                           forwardUrl: String = DataManager.singleton.forwardDisplayUrl,
                           displayUrl: String = DataManager.singleton.displayUrl) -> Bool {
        // MARK: - HACK
        var isLists:[Bool] = []
        
        switch type {
        case .login:
            isLists.append(!forwardUrl.contains(Url.lostConnection.string()))
            isLists.append(displayUrl.contains(Url.lostConnection.string()))
            isLists.append(displayUrl.suffix(2)=="s1")
            isLists.append(canLogedInServiece)
            
            
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
            isLists.append(!canLogedInServiece)
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
        if canLogedInServiece {
            let lists = dataManager.settingCellList
            for list in lists {
                if list.initialView {
                    if let url = URL(string: list.url) {
                        return URLRequest(url: url)
                    }
                }
            }
            guard let url = URL(string: Url.manabaHomePC.string()) else {fatalError()}
            return URLRequest(url: url)
        }
        guard let url = URL(string: Url.systemServiceList.string()) else {fatalError()}
        return URLRequest(url: url)
    }
    
    // cアカウント、パスワードを登録しているか判定
    private var canLogedInServiece: Bool { get { return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty) }}
}
