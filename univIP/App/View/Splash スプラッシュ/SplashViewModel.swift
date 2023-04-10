//
//  HomeViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Alamofire

class SplashViewModel {
    
    public let dataManager = DataManager.singleton
    public let apiManager = ApiManager.singleton
    
    public var prItems:[PublicRelations] = []
    public var displayedPRImage: PublicRelations?
    public var weatherData:Weather?
    
    public var progressStatus = 10
    
    //MARK: - STATE ステータス
    enum State {
        case busy  // 準備中
        case ready // 準備完了
        case error // エラー発生
    }
    // 通信情報の更新
    public var state: ((State) -> Void)?
    
    
    // MARK: - Public func
    /// 利用規約に同意する必要があるかどうか
    public func isTermsOfServiceAgreementNeeded() -> Bool {
        // 同意済みの利用規約Ver と 最新の利用規約Ver を比べる
        return dataManager.agreementVersion != ConstStruct.latestTermsVersion
    }
    
    /// GitHubからPRの情報を取ってくる
    public func getPRItems() {
        prItems.removeAll()
        self.state?(.busy) // 開始
        
        apiManager.request(Url.prItemJsonData.string(),
                           success: { [weak self] (response) in
            guard let self = self else {
                fatalError()
            }
            
            let prItemCounts = response["itemCounts"].int ?? 0
            
            // response["items"] に入っている情報を1つづつprItemsに追加する
            for i in 0 ..< prItemCounts {
                let prItem = PublicRelations(imageURL: response["items"][i]["imageURL"].string,
                                             introduction: response["items"][i]["introduction"].string,
                                             tappedURL: response["items"][i]["tappedURL"].string,
                                             organization_name: response["items"][i]["organization_name"].string,
                                             description: response["items"][i]["description"].string)
                self.prItems.append(prItem)
            }
            self.state?(.ready) // 終了
            
        }, failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] getPRItems: failure:\(error.localizedDescription)")
            self?.state?(.error) // エラー表示
        })
    }
    
    /// パスワードを登録しているか
    public func isPasswordRegistered() -> Bool {
        return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty)
    }
    
    /// タイムアウトしているか
    public func isTimeoutOccurredForURL(urlStr: String) -> Bool {
        return urlStr == Url.universityServiceTimeOut.string() || urlStr == Url.universityServiceTimeOut2.string()
    }
    
    /// ログインが完了しているか
    public func isLoginCompletedForURL(_ urlStr: String) -> Bool {
        // ログインが完了後のURL(3種類)
        let check1 = urlStr.contains(Url.skipReminder.string())
        let check2 = urlStr.contains(Url.courseManagementPC.string())
        let check3 = urlStr.contains(Url.courseManagementMobile.string())
        let check4 = urlStr.contains("https://eweb.stud.tokushima-u.ac.jp/Shibboleth.sso/SAML2/POST")
        
        // 上記から1つでもtrueがあれば、result = true
        let result = check1 || check2 || check3 || check4

        return (dataManager.loginState.isProgress && result)
    }
    
    /// ログインに失敗しているか
    public func isLoginFailedForURL(_ urlStr: String) -> Bool {
        /*
         Note:
         
         ログインが失敗時のURL
         セッション1回目、ログイン失敗0回目
         "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1"
         セッションn回目
         ".../SAML2/Redirect/SSO?execution=e{n}s1"
         ログイン失敗n回目
         ".../SAML2/Redirect/SSO?execution=e1s{n-1}"
         */
        let check1 = urlStr.contains(Url.universityLogin.string())
        let check2 = (urlStr.suffix(2) != "s1") // ログイン失敗1回以上か
        // 上記からどちらもtrueであれば、result = true
        let result = check1 && check2
        
        // ログイン処理中かつ、ログイン失敗した時のURL
        if dataManager.loginState.isProgress, result {
            dataManager.loginState.isProgress = false
            return true
        }
        return false
    }
    
    /// JavaScriptを動かしたいURLか
    public func canRunJavaScriptOnURL(_ urlString: String) -> Bool {
        // JavaScriptを実行するフラグ
        if dataManager.canExecuteJavascript == false { return false }
        
        // パスワードを登録しているか
        if isPasswordRegistered() == false { return false }
        
        // ログインに失敗したか
        if isLoginFailedForURL(urlString) {return false}
        
        // ログイン画面の判定
        if urlString.contains(Url.universityLogin.string()) { return true }
        
        // それ以外なら
        return false
    }
    
    
    // MARK: - Private func
    
    /// plistを読み込み
    private func loadPlist(path: String, key: String) -> String{
        let filePath = Bundle.main.path(forResource: path, ofType:"plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        
        guard let pl = plist else{
            AKLog(level: .ERROR, message: "plistが存在しません")
            return ""
        }
        return pl[key] as! String
    }
    
    enum flagType {
        case notStart
        case loginStart
        case loginSuccess
        case loginFailure
        case executedJavaScript
    }
    public func updateLoginFlag(type: flagType) {
        switch type {
        case .notStart:
            dataManager.canExecuteJavascript = false
            dataManager.loginState.isProgress = false
            dataManager.loginState.completed = false
            
        case .loginStart:
            dataManager.canExecuteJavascript = true // ログイン用のJavaScriptを動かす
            dataManager.loginState.isProgress = true // ログイン処理中
            dataManager.loginState.completed = false // ログインが完了していない
            
        case .loginSuccess:
            dataManager.canExecuteJavascript = false
            dataManager.loginState.isProgress = false
            dataManager.loginState.completeImmediately = true
            dataManager.loginState.completed = true
            
        case .loginFailure:
            dataManager.canExecuteJavascript = false
            dataManager.loginState.isProgress = false
            dataManager.loginState.completed = false
            
        case .executedJavaScript:
            // Dos攻撃を防ぐ為、1度ログインに失敗したら、JavaScriptを動かすフラグを下ろす
            dataManager.canExecuteJavascript = false
            dataManager.loginState.isProgress = true
            dataManager.loginState.completed = false
        }
    }
}
