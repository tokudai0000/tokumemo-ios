//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation
import Kanna

final class MainViewModel {
    
    private let dataManager = DataManager.singleton
    
    // シラバスをJavaScriptで自動入力する際、参照変数
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
        // ドメインを検証
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
    /// JavaScriptを実行する場合かつ、URLと登録したJavaScriptを動かしたいURLと一致したら
    /// - Parameter url: 現在、表示中のURL
    /// - Returns: 動かすJavaScriptの種類
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
    
    /// 設定した初期画面を探す
    /// - Returns: 設定した初期画面のURLRequest
    public func searchInitialViewUrl() -> URLRequest {
        
        for menuList in dataManager.menuLists {
            // ユーザーが指定した初期画面を探す
            if menuList.isInitView {
                // メニューリストの内1つだけ、isInitView=trueが存在する
                
                // 登録者か非登録者か判定
                if dataManager.shouldInputedPassword {
                    // パスワードを登録していない場合
                    if menuList.id == .manabaHomePC {
                        // パスワード登録しておらず、初期画面がマナバである時は大学のホームページを表示させる
                        let url = URL(string: Url.universityHomePage.string())! // fatalError
                        return URLRequest(url: url)
                    }
                }
                
                let urlString = menuList.url!         // fatalError **Constant.Menu(canInitView)を設定してる為、URLが存在することを保証している**
                let url = URL(string: urlString)!     // fatalError
                return URLRequest(url: url)
            }
        }
        
        // 必ず初期画面が設定されている
        fatalError()
    }
    
    
    // 図書館の所在[常三島(本館Main) , 蔵本(分館Kura)]
    enum LibraryType {
        case main
        case kura
    }
    /// 図書館の開館カレンダーをweb画面からスクレイピングする
    /// - Parameter type: 図書館の所在[常三島(本館Main) , 蔵本(分館Kura)]
    /// - Returns: 動的URL
    public func fetchLibraryCalendarUrl(type: LibraryType) -> URLRequest? {
        var urlString = ""
        switch type {
            case .main:
                urlString = Url.libraryHomePageMainPC.string()
            case .kura:
                urlString = Url.libraryHomePageKuraPC.string()
        }
        
        let url = URL(string: urlString)! // fatalError
        
        do {
            let data = NSData(contentsOf: url as URL)
            let doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
            for node in doc.xpath("//a") {
                guard let str = node["href"] else {
                    return nil
                }
                if str.contains("pub/pdf/calender/calender") {
                    let urlString = "https://www.lib.tokushima-u.ac.jp/" + node["href"]!
                    if let url = URL(string: urlString) {
                        return URLRequest(url: url)
                        
                    } else {
                        AKLog(level: .FATAL, message: "URLフォーマットエラー")
                        return nil
                    }
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    // cアカウント、パスワードを登録しているか判定
    private var canLoggedInService: Bool { get { return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty) }}
}
