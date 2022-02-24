//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Kanna
import FirebaseAnalytics

final class MainViewModel {
    
    // Favorite画面へURLを渡すのに使用
    public var urlString = ""
    
    // シラバスをJavaScriptで自動入力する際、参照変数
    public var subjectName = ""
    public var teacherName = ""
    
    // ログイン処理中かどうか
    public var isLoginProcessing = true
    
    private let dataManager = DataManager.singleton
    
    // 最新の利用規約同意者か判定し、同意画面の表示を行うべきか判定
    public var shouldDisplayTermsAgreementView: Bool {
        get { return dataManager.agreementVersion != Constant.latestTermsVersion }
    }
    
    /// 現在読み込み中のURL(displayUrl)が許可されたドメインかどうか
    /// - Returns: 許可されているドメイン名ならtrueを返す
    public func isAllowedDomainCheck(_ url: URL) -> Bool {
        // ホストを取得
        guard let hostDomain = url.host else {
            AKLog(level: .ERROR, message: "[Domain取得エラー] \n url:\(url)")
            return false
        }
        // ドメインを検証
        for domain in Constant.allowedDomains {
            if hostDomain.contains(domain) {
                // 許可されたドメインと一致している場合
                return true
            }
        }
        return false
    }
    
    enum JavaScriptType {
        case universityLogin
        case syllabusFirstTime
        case outlookLogin
        case tokudaiCareerCenter
        case none
    }
    /// JavaScriptを実行する場合かつ、URLと登録したJavaScriptを動かしたいURLと一致したら
    /// - Parameter urlString: 現在、表示中のURLString
    /// - Returns: 動かすJavaScriptの種類
    public func anyJavaScriptExecute(_ urlString: String) -> JavaScriptType {
        // JavaScriptを実行するフラグが立っていない場合は抜ける
        if !dataManager.isExecuteJavascript {
            return .none
        }
        
        // 大学サイト、ログイン画面 && cアカウント、パスワードを登録しているか
        if urlString.contains(Url.universityLogin.string()) && hasRegisteredPassword {
            return .universityLogin
        }
        // シラバス
        if urlString == Url.syllabus.string() {
            return .syllabusFirstTime
        }
        // outlook(メール) && 登録者判定
        if urlString.contains(Url.outlookLoginForm.string()) && hasRegisteredPassword {
            return .outlookLogin
        }
        // 徳島大学キャリアセンター
        if urlString == Url.tokudaiCareerCenter.string() {
            return .tokudaiCareerCenter
        }
        
        return .none
    }
    
    /// 設定した初期画面を探す
    /// - Returns: 設定した初期画面のURLRequest
    public func searchInitialViewUrl() -> URLRequest {
        // メニューリストの内1つだけ、isInitView=trueが存在するので探す
        for menuList in dataManager.menuLists {
            // ユーザーが指定した初期画面を探す
            if menuList.isInitView {
                // パスワード登録しておらず、初期画面がマナバである時は大学のホームページを表示させる
                if dataManager.shouldInputedPassword && (menuList.id == .manabaHomePC)  {
                    let url = URL(string: Url.universityHomePage.string())! // fatalError
                    return URLRequest(url: url)
                }
                let urlString = menuList.url!         // fatalError **Constant.Menu(canInitView)を設定してる為、URLが存在することを保証している**
                let url = URL(string: urlString)!     // fatalError
                return URLRequest(url: url)
            }
        }
        // 見つからなかった場合
        // お気に入り画面を初期画面に設定しており、カスタマイズから削除した可能性がある
        let urlString = Url.manabaPC.string()
        let url = URL(string: urlString)!     // fatalError
        return URLRequest(url: url)
    }
    
    /// 図書館の開館カレンダーをweb画面からスクレイピングする[常三島(本館Main) , 蔵本(分館Kura)]
    /// - Parameter url: 図書館のwebページ
    /// - Returns: 動的URL
    public func fetchLibraryCalendarUrl(_ url: URL) -> URLRequest? {        
        do {
            // urlのHTMLデータを取得
            let htmlData = NSData(contentsOf: url as URL)! as Data
            let doc = try HTML(html: htmlData, encoding: String.Encoding.utf8)
            // aタグを抽出
            for node in doc.xpath("//a") {
                // href属性に設定されている文字列を出力
                guard let str = node["href"] else {
                    AKLog(level: .ERROR, message: "[href属性出力エラー]: href属性に設定されている文字列を出力する際のエラー")
                    return nil
                }
                // 開館カレンダーは図書ホームページのカレンダーボタンにPDFへのURLが埋め込まれている
                if str.contains("pub/pdf/calender/calender") {
                    // PDFまでのURLを作成する
                    let pdfUrlString = url.absoluteString + str
                    
                    if let url = URL(string: pdfUrlString) {
                        return URLRequest(url: url)
                    } else {
                        AKLog(level: .ERROR, message: "[URLフォーマットエラー]: 図書館開館カレンダーURL取得エラー \n pdfUrlString:\(pdfUrlString)")
                        return nil
                    }
                }
            }
            AKLog(level: .ERROR, message: "[URL抽出エラー]: 図書館開館カレンダーURLの抽出エラー \n urlString:\(url.absoluteString)")
        } catch {
            AKLog(level: .ERROR, message: "[Data取得エラー]: 図書館開館カレンダーHTMLデータパースエラー\n urlString:\(url.absoluteString)")
        }
        return nil
    }
    
    /// 初期画面(マナバなど)を読み込むべきかどうか
    /// - Parameter urlString: 現在表示しているURLString
    /// - Returns: 判定結果
    public func shouldDisplayInitialWebPage(_ urlString: String) -> Bool {
        // ログイン処理中かつ、ログインURLと異なっている場合(URLが同じ場合はログイン失敗した状態)
        if isLoginProcessing && (urlString.contains(Url.universityLogin.string()) == false) {
            // ログイン処理を終了する
            isLoginProcessing = false
            return true
        }
        return false
    }
    
    /// 現在の時刻を記録する
    public func saveTimeUsedLastTime() {
        // 現在の時刻を取得し保存
        let f = DateFormatter()
        f.setTemplate(.full)
        let now = Date()
        dataManager.saveTimeUsedLastTime = f.string(from: now)
    }
    
    /// 再度ログイン処理を行うべきか
    /// - Returns: 行うべきならtrue
    public func shouldExecuteLogin() -> Bool {
        // dataManagerのsaveTimeUsedLastTime(String型)をDateに変換する
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "MM/dd/yyyy, HH:mm:ss"
        if let lastTime = formatter.date(from: dataManager.saveTimeUsedLastTime) {
            // 現在の時刻を取得
            let f = DateFormatter()
            f.setTemplate(.time)
            let now = Date()
            // 時刻の差分が30*60分以上であれば再ログインを行う
            if now.timeIntervalSince(lastTime) > 30 * 60 {
                return true
            }
        }
        return false
    }
    
    /// タイムアウトのURLであるかどうかの判定
    /// - Parameter urlString: 現在表示しているURLの文字列
    /// - Returns: 結果
    public func isTimeOut(_ urlString: String) -> Bool {
        return urlString == Url.universityServiceTimeOut.string()
    }
    
    /// FireBaseアナリティクスを送信する
    /// - Parameter urlString: 読み込まれたURLの文字列
    public func analytics(_ urlString: String) {
        // Analytics
        Analytics.logEvent("WebViewReload", parameters: ["pages": urlString])
    }
    
    // MARK: - Private
    // cアカウント、パスワードを登録しているか判定
    private var hasRegisteredPassword: Bool { get { return (!dataManager.cAccount.isEmpty && !dataManager.password.isEmpty) }}
}
