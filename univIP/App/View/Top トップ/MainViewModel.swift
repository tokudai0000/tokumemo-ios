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
    
    // JavaScriptを実行するかどうか
    public var isExecuteJavascript = false
    
    // 利用規約同意者か判定
    public var hasAgreedTermsOfUse: Bool {
        get { return dataManager.agreementVersion == Constant.agreementVersion }
    }
    
    /// 現在読み込み中のURL(displayUrl)が許可されたドメインかどうか
    /// - Returns: 許可されているドメイン名ならtrueを返す
    public func isAllowedDomainCheck(_ url: URL) -> Bool {
        
        guard let hostDomain = url.host else {
                  AKLog(level: .ERROR, message: "[Domain取得エラー] \n displayUrlString:\(dataManager.displayUrlString)")
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
    public func isJudgeUrl(type: isJudgeType, forUrl: String = DataManager.singleton.forwardDisplayUrlString) -> Bool {
    
        let forwardUrlString = dataManager.forwardDisplayUrlString
        let displayUrlString = dataManager.displayUrlString
        
        var isLists:[Bool] = []
        
        switch type {
            case .universityLogin:
                // 大学サイト、ログイン画面
                isLists.append(displayUrlString.contains(Url.universityLogin.string()))
                // ログインに失敗した場合前のURLと被るためjavascriptを動かさないためにfalseを入れる
                isLists.append(!forwardUrlString.contains(Url.universityLogin.string()))
                // JavaScriptを動かしcアカウント、パスワードを自動入力する必要があるのか判定
                isLists.append(canLoggedInService)
                
            case .syllabusFirstTime:
                // シラバス
                isLists.append(displayUrlString == Url.syllabus.string())
                // 2回目からはfalse
                isLists.append(forwardUrlString != Url.syllabus.string())
                
            case .outlookLogin:
                // outlook(メール)
                isLists.append(displayUrlString.contains(Url.outlookLogin.string()))
                // ログインに失敗した場合前のURLと被るためjavascriptを動かさないためにfalseを入れる
                isLists.append(!forwardUrlString.contains(Url.outlookLogin.string()))
                // 登録者判定
                isLists.append(canLoggedInService)
                
            case .tokudaiCareerCenter:
                // 徳島大学キャリアセンター
                isLists.append(displayUrlString == Url.tokudaiCareerCenter.string())
                // ログインに失敗した場合前のURLと被るためjavascriptを動かさないためにfalseを入れる
                isLists.append(!forwardUrlString.contains(Url.tokudaiCareerCenter.string()))
                
            case .questionnaireReminder:
                // アンケート催促画面(教務事務表示前に出現)
                isLists.append(displayUrlString.contains(Url.enqueteReminder.string()))
                
            case .universityServiceTimeOut:
                // タイムアウト(20分無操作)
                isLists.append(displayUrlString == Url.universityServiceTimeOut.string())
        }
        // 配列内全てがtrueならtrueを返す、それ以外ならfalse
        return isLists.allSatisfy{ $0 == true }
    }
    
    
    public func searchInitialViewUrl() -> URLRequest {
        // MARK: - 修正必要あり
        // 登録者、非登録者の条件分岐必要
        for list in dataManager.menuLists[0] {
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
