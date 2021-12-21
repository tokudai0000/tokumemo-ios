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
    public func isAllowedDomainCheck() -> Bool {
        
        guard let url = URL(string: dataManager.displayUrlString),
              let hostDomain = url.host else {
                  return false
//                  AKLog(level: .FATAL, message: dataManager.displayUrlString)
//                  AKLog(level: .FATAL, message: url.host)
//                  fatalError()
              }
        
        for allowedUrl in Constant.allowedDomains {
            if hostDomain.contains(allowedUrl) {
                return true
            }
        }
        return false
        
    }
    
    
    enum isJudgeType {
        case universityLogin
        case syllabusFirstTime
        case outlookLogin
        case tokudaiCareerCenter
        case questionnaireReminder
        case universityServiceTimeOut
    }
    /// 読み込み中のURLとisJudgeTypeが同じか、JavaScriptを動かす必要があるかを判定する
    /// - Parameter type:判定させたいパラメータ
    /// - Returns: 判定結果
    public func isJudgeUrl(type: isJudgeType) -> Bool {
    
        let forwardUrlString = dataManager.forwardDisplayUrlString
        let displayUrlString = dataManager.displayUrlString
        
        var isLists:[Bool] = []
        
        switch type {
            case .universityLogin:
                // 大学サイト、ログイン画面
                isLists.append(displayUrlString.contains(Url.universityLogin.string()))
                // ログインに失敗した場合false
                isLists.append(!forwardUrlString.contains(Url.universityLogin.string()))
                // JavaScriptを動かしcアカウント、パスワードを自動入力する必要があるのか判定
                isLists.append(canLogedInServiece)
                
            case .syllabusFirstTime:
                // シラバス
                isLists.append(displayUrlString == Url.syllabus.string())
                // 2回目からはfalse
                isLists.append(forwardUrlString != Url.syllabus.string())
                
            case .outlookLogin:
                // outlook(メール)
                isLists.append(displayUrlString.contains(Url.outlookLogin.string()))
                // ログインに失敗した場合false
                isLists.append(!forwardUrlString.contains(Url.outlookLogin.string()))
                
            case .tokudaiCareerCenter:
                // 徳島大学キャリアセンター
                isLists.append(displayUrlString == Url.tokudaiCareerCenter.string())
                // ログインに失敗した場合false
                isLists.append(!forwardUrlString.contains(Url.tokudaiCareerCenter.string()))
                
            case .questionnaireReminder:
                // アンケート催促画面(教務事務表示前に出現)
                isLists.append(displayUrlString.contains(Url.enqueteReminder.string()))
                
            case .universityServiceTimeOut:
                // タイムアウト(20分無操作)
                isLists.append(displayUrlString == Url.universityServiceTimeOut.string())
        }
        // 配列内全てがtrueならtrueを返す
        return isLists.allSatisfy{ $0 == true }
    }
    
    
    public func searchInitialViewUrl() -> URLRequest {
        // MARK: - 修正必要あり
        // 登録者、非登録者の条件分岐必要
        for list in dataManager.menuLists[0] {
            if list.isInitView {
                guard let url = URL(string: list.url) else { fatalError() }
                return URLRequest(url: url)
            }
        }
        // もし表示されない場合は
        guard let url = URL(string: Url.systemServiceList.string()) else { fatalError() }
        return URLRequest(url: url)
    }
    
    // cアカウント、パスワードを登録しているか判定
    private var canLogedInServiece: Bool { get { return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty) }}
}
