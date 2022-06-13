//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation

final class MainViewModel {
    
    /// Favorite画面へURLを渡すのに使用
    public var urlString = ""
    
    /// シラバスをJavaScriptで自動入力する際、参照変数
    public var subjectName = ""
    public var teacherName = ""
    
    /// ログイン処理中かどうか
    public var isLoginProcessing = false
    
    /// 最新の利用規約同意者か判定し、同意画面の表示を行うべきか判定
    public var shouldShowTermsAgreementView: Bool {
        get { return dataManager.agreementVersion != Constant.latestTermsVersion }
    }
    
    /// URLの読み込みを許可するか判定
    /// ドメイン名が許可しているのと一致しているなら許可(ホワイトリスト制)
    /// - Parameter url: 判定したいURL
    /// - Returns: 判定結果、許可ならtrue
    public func isAllowedDomainCheck(_ url: URL) -> Bool {
        // ドメイン名を取得
        guard let domain = url.host else {
            AKLog(level: .ERROR, message: "[Domain取得エラー] \n url:\(url)")
            return false
        }
        // ドメインを検証
        for item in Constant.allowedDomains {
            if domain.contains(item) {
                // 一致したなら
                return true
            }
        }
        return false
    }
    
    /// JavaScriptを動かす種類
    enum JavaScriptType {
        case skipReminder // アンケート解答の催促画面
        case syllabus // シラバスの検索画面
        case loginIAS // 大学統合認証システム(IAS)のログイン画面
        case loginOutlook // メール(Outlook)のログイン画面
        case loginCareerCenter // 徳島大学キャリアセンターのログイン画面
        case none // JavaScriptを動かす必要がない場合
    }
    /// JavaScriptを動かしたい指定のURLかどうかを判定し、動かすJavaScriptの種類を返す
    ///
    /// - Note: canExecuteJavascriptが重要な理由
    ///   ログインに失敗した場合に再度ログインのURLが表示されることになる。
    ///   canExecuteJavascriptが存在しないと、再度ログインの為にJavaScriptが実行され続け無限ループとなってしまう。
    /// - Parameter urlString: 読み込み完了したURLの文字列
    /// - Returns: 動かすJavaScriptの種類
    public func anyJavaScriptExecute(_ urlString: String) -> JavaScriptType {
        // パスワードが間違っていてかつ、利用規約同意画面が表示されるとクラッシュする(裏でアラートが表示されるから)対策
        if shouldShowTermsAgreementView {
            return .none
        }
        // JavaScriptを実行するフラグが立っていない場合はnoneを返す
        if dataManager.canExecuteJavascript == false {
            return .none
        }
        // アンケート解答の催促画面
        if urlString == Url.skipReminder.string() {
            return .skipReminder
        }
        // シラバスの検索画面
        if urlString == Url.syllabus.string() {
            return .syllabus
        }
        // cアカウント、パスワードを登録しているか
        if hasRegisteredPassword == false {
            return .none
        }
        // 大学統合認証システム(IAS)のログイン画面
        if urlString.contains(Url.universityLogin.string()) {
            return .loginIAS
        }
        // メール(Outlook)のログイン画面
        if urlString.contains(Url.outlookLoginForm.string()) {
            return .loginOutlook
        }
        // 徳島大学キャリアセンターのログイン画面
        if urlString == Url.tokudaiCareerCenter.string() {
            return .loginCareerCenter
        }
        // それ以外なら
        return .none
    }

    /// 初期画面に指定したWebページのURLを返す
    ///
    /// ログイン処理完了後に呼び出される。つまり、ログインが完了したユーザーのみが呼び出す。
    /// structure Menu に存在するisInitViewがtrueであるのを探し、そのURLRequestを返す
    /// 何も設定していないユーザーはマナバ(初期値)を表示させる。
    /// - Note:
    ///   isInitViewは以下の1つの事例を除き、必ずtrueは存在する。
    ///   1. お気に入り登録内容を初期設定画面に登録し、カスタマイズから削除した場合
    /// - Returns: 設定した初期画面のURLRequest
    public func searchInitPageUrl() -> URLRequest {
        // メニューリストの内1つだけ、isInitView=trueが存在するので探す
        for menuList in dataManager.menuLists {
            // 初期画面を探す
            if menuList.isInitView,
               let urlString = menuList.url,
               let url = URL(string: urlString) {
                return URLRequest(url: url)
            }
        }
        // 見つからなかった場合
        // お気に入り画面を初期画面に設定しており、カスタマイズから削除した可能性がある為
        // マナバを表示させる
        return Url.manabaPC.urlRequest()
    }
    
    /// 大学統合認証システム(IAS)へのログインが完了したかどうか
    ///
    /// 以下2つの状態なら完了とする
    ///  1. ログイン後のURLが指定したURLと一致していること
    ///  2. ログイン処理中であるフラグが立っていること
    ///  認められない場合は、falseとする
    /// - Note:
    /// - Parameter urlString: 現在表示しているURLString
    /// - Returns: 判定結果、許可ならtrue
    /// hadLoggedin
    public func isLoggedin(_ urlString: String) -> Bool {
        // ログイン後のURLが指定したURLと一致しているかどうか
        let check1 = urlString.contains(Url.skipReminder.string())
        let check2 = urlString.contains(Url.courseManagementPC.string())
        let check3 = urlString.contains(Url.courseManagementMobile.string())
        // 上記から1つでもtrueがあれば、引き継ぐ
        let result = check1 || check2 || check3
        // ログイン処理中かつ、ログインURLと異なっている場合(URLが同じ場合はログイン失敗した状態)
        if isLoginProcessing, result {
            // ログイン処理を完了とする
            isLoginProcessing = false
            return true
        }
        return false
    }
    
    /// 現在の時刻を保存する
    public func saveCurrentTime() {
        // 現在の時刻を取得し保存
        let f = DateFormatter()
        f.setTemplate(.full)
        let now = Date()
        dataManager.setUserDefaultsString(key: KEY_saveCurrentTime, value: f.string(from: now))
    }
    
    /// 再度ログイン処理を行うかどうか
    ///
    /// - Returns: 判定結果、行うべきならtrue
    public func isExecuteLogin() -> Bool {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy, HH:mm:ss"
        let lastTime = formatter.date(from: dataManager.getUserDefaultsString(key: KEY_saveCurrentTime))
        guard let lastTime = lastTime else {
            return false
        }
        
        // 現在の時刻を取得
        let now = Date()
        print(now.timeIntervalSince(lastTime))
        // 時刻の差分が30*60秒未満であれば再ログインしない
        if now.timeIntervalSince(lastTime) < 30 * 60 {
            return false
        }
        isLoginProcessing = true
        return true
    }
    
    /// タイムアウトのURLであるかどうかの判定
    /// - Parameter urlString: 読み込み完了したURLの文字列
    /// - Returns: 結果
    public func isTimeout(_ urlString: String) -> Bool {
        if urlString == Url.universityServiceTimeOut.string() ||
            urlString == Url.universityServiceTimeOut2.string() {
            return true
        }
        return false
    }
    
    // MARK: - Private
    
    private let dataManager = DataManager.singleton
    
    // cアカウント、パスワードを登録しているか判定
    public var hasRegisteredPassword: Bool { get { return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty) }}
    
    // 前回利用した時間を保存
    private let KEY_saveCurrentTime = "KEY_saveCurrentTime"
}
