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
    
    // 利用規約同意者か判定
    public var hasAgreedTermsOfUse: Bool {
        get { return dataManager.agreementVersion == Constant.agreementVersion }
    }
    
    /// 現在読み込み中のURL(displayUrl)が許可されたドメインかどうか
    /// - Returns: 許可されているドメイン名ならtrueを返す
    public func isAllowedDomainCheck(_ url: URL) -> Bool {
        
        guard let hostDomain = url.host else {
                  AKLog(level: .ERROR, message: "[Domain取得エラー] \n url:\(url)")
                  return false
              }
        
        for domainString in Constant.allowedDomains {
            if hostDomain.contains(domainString) {
                // 許可されたdomainと一致している場合
                return true
            }
        }
        return false
        
    }
    
    
    enum JavaScriptType {
        case universityLogin
        case questionnaireReminder
        case syllabusFirstTime
        case outlookLogin
        case tokudaiCareerCenter
        case none
    }
    public func anyJavaScriptExecute(_ url: URL) -> JavaScriptType {

        let urlString = url.absoluteString
        
        // JavaScriptを実行するフラグが立っていない場合は抜ける
        if !dataManager.isExecuteJavascript {
            return .none
        }
        // フラグを下ろす
        dataManager.isExecuteJavascript = false
        // 大学サイト、ログイン画面 && JavaScriptを動かしcアカウント、パスワードを自動入力する必要があるのか判定
        if urlString.contains(Url.universityLogin.string()) && canLoggedInService {
            return .universityLogin
        }
        // シラバス
        if urlString == Url.syllabus.string() {
            return .syllabusFirstTime
        }
        // outlook(メール) && 登録者判定
        if urlString.contains(Url.outlookLogin.string()) && canLoggedInService {
            return .outlookLogin
        }
        // 徳島大学キャリアセンター
        if urlString == Url.tokudaiCareerCenter.string() {
            return .tokudaiCareerCenter
        }
        // アンケート催促画面(教務事務表示前に出現)
        if urlString.contains(Url.enqueteReminder.string()) {
            return .questionnaireReminder
        }
        
        return .none
        
    }
    
    public func searchInitialViewUrl() -> URLRequest {
        // MARK: - 修正必要あり
        // 登録者、非登録者の条件分岐必要
        for list in dataManager.menuLists {
            if list.isInitView {
                let urlString = list.url!         // fatalError 
                let url = URL(string: urlString)! // fatalError
                return URLRequest(url: url)
            }
        }
        // もし表示されない場合は
        guard let url = URL(string: Url.systemServiceList.string()) else { fatalError() }
        return URLRequest(url: url)
    }
    
    // cアカウント、パスワードを登録しているか判定
    private var canLoggedInService: Bool { get { return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty) }}
}
