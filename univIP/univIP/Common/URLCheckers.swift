//
//  URLCheckers.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

struct URLCheckers {

    /// URLが大学サイトのログイン画面であり、JavaScriptを挿入できるかを確認します。
    /// - Parameters:
    ///   - urlString: 確認するURLの文字列
    ///   - canExecuteJavascript: JavaScriptの実行が許可されているかどうか
    /// - Returns: JavaScriptを挿入できる場合は`true`、そうでない場合は`false`
    static func canInjectJavaScriptForUniversityLoginURL(at urlString: String, _ canExecuteJavascript: Bool) -> Bool {
        if canExecuteJavascript == false { return false }
        return urlString.contains(Url.universityLogin.string())
    }

    /// URLが大学サイトのアンケート催促画面かを確認します。
    /// - Parameter urlString: 確認するURLの文字列
    /// - Returns: アンケート催促のURLである場合は`true`、そうでない場合は`false`
    static func isSkipReminderURL(at urlString: String) -> Bool {
        return urlString.contains(Url.skipReminder.string())
    }

    /// URLが大学サイトのタイムアウト画面かを確認します。(2通り存在)
    /// - Parameter urlStr: 確認するURLの文字列
    /// - Returns: タイムアウトのURLである場合は`true`、そうでない場合は`false`
    static func isUniversityServiceTimeoutURL(at urlStr: String) -> Bool {
        return urlStr == Url.universityServiceTimeOut.string() || urlStr == Url.universityServiceTimeOut2.string()
    }

    /// URLが大学サイトのログイン直後かを確認します。(3通り存在)
    /// - Parameter urlStr: 確認するURLの文字列
    /// - Returns: ログイン直後のURLである場合は`true`、そうでない場合は`false`
    static func isImmediatelyAfterLoginURL(at urlStr: String) -> Bool {
        let targetURLs = [Url.skipReminder.string(),
                          Url.courseManagementMobile.string(),
                          Url.courseManagementPC.string()]
        return targetURLs.contains(urlStr)
    }
}
