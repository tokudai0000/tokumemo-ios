//
//  URLCheckers.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

public struct URLCheckers {

    public enum UrlType {
        case universityLogin       // 大学のログインページ
        case outlookLoginForm      // Outlookのログインフォーム
        case tokudaiCareerCenter   // 特大キャリアセンター
    }
    /// 指定されたURLにJavaScriptを挿入できるかどうかを判断します。
    /// - Parameters:
    ///   - urlString: 確認するURLの文字列
    ///   - canExecuteJavascript: JavaScriptの実行が許可されているかどうかのフラグ
    ///   - urlType: 確認するURLのタイプ
    /// - Returns: JavaScriptを挿入できる場合は`true`、そうでない場合は`false`
    public static func shouldInjectJavaScript(at urlString: String, _ canExecuteJavascript: Bool, for urlType: UrlType) -> Bool {
        if canExecuteJavascript == false { return false }
        switch urlType {
        case .universityLogin:
            return urlString.contains(Url.universityLogin.string())
        case .outlookLoginForm:
            return urlString.contains(Url.outlookLoginForm.string())
        case .tokudaiCareerCenter:
            return urlString.contains(Url.tokudaiCareerCenter.string())
        }
    }

    /// URLが大学サイトのアンケート催促画面かを確認します。
    /// - Parameter urlString: 確認するURLの文字列
    /// - Returns: アンケート催促のURLである場合は`true`、そうでない場合は`false`
    public static func isSkipReminderURL(at urlString: String) -> Bool {
        return urlString.contains(Url.skipReminder.string())
    }

    /// URLが大学サイトのタイムアウト画面かを確認します。(2通り存在)
    /// - Parameter urlStr: 確認するURLの文字列
    /// - Returns: タイムアウトのURLである場合は`true`、そうでない場合は`false`
    public static func isUniversityServiceTimeoutURL(at urlStr: String) -> Bool {
        return urlStr == Url.universityServiceTimeOut.string() || urlStr == Url.universityServiceTimeOut2.string()
    }

    /// URLが大学サイトのログインに失敗し、再入力を求められている画面かを確認します。
    /// 初回ログイン https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1
    /// 1回ログイン失敗 https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s2
    /// 2回ログイン失敗 https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s3
    /// - Parameter urlStr: 確認するURLの文字列
    /// - Returns: ログインに失敗した際のURLである場合は`true`、そうでない場合は`false`
    public static func isFailureUniversityServiceLoggedInURL(at urlStr: String) -> Bool {
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
    /// 1, アンケート最速画面
    /// 2, 教務事務システムのモバイル画面(iPhone)
    /// 3, 教務事務システムのPC画面(iPad)
    /// - Parameter urlStr: 確認するURLの文字列
    /// - Returns: ログイン直後のURLである場合は`true`、そうでない場合は`false`
    public static func isImmediatelyAfterLoginURL(at urlStr: String) -> Bool {
        let targetURLs = [Url.skipReminder.string(),
                          Url.courseManagementMobile.string(),
                          Url.courseManagementPC.string()]
        return targetURLs.contains(urlStr)
    }
}
