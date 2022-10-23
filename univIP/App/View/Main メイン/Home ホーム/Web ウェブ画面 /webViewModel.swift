//
//  webViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/17.
//

import Foundation

final class WebViewModel {
    
    private let dataManager = DataManager.singleton
    
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
//        // cアカウント、パスワードを登録しているか
//        if hasRegisteredPassword == false {
//            return .none
//        }
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
}
