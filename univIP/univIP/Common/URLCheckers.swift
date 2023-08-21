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

    /// URLが大学サイトのログインに失敗し、再入力を求められている画面かを確認します。
    /// 初回ログイン https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1
    /// 1回ログイン失敗 https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s2
    /// 2回ログイン失敗 https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s3
    /// - Parameter urlStr: 確認するURLの文字列
    /// - Returns: ログインに失敗した際のURLである場合は`true`、そうでない場合は`false`
    static func isFailureUniversityServiceLoggedInURL(at urlStr: String) -> Bool {
        // execution=e1s1 や execution=e1s2 となる
        if urlStr.contains("https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=") {
            let start = urlStr.index(urlStr.endIndex, offsetBy: -2)
            let end = urlStr.index(urlStr.endIndex, offsetBy: 0)
            // 下2桁を比較
            if String(urlStr[start..<end]) != "s1" {
                return true
            }
        }
        return false
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
