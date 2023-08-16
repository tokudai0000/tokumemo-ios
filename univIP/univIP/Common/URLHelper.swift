//
//  URLHelper.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation

struct URLHelper {
    static func shouldInjectJavaScript(at urlString: String, _ canExecuteJavascript: Bool) -> Bool {
        if canExecuteJavascript == false { return false }
        if urlString.contains(Url.universityLogin.string()) { return true }
        return false
    }

    static func isUniversityServiceTimeoutURL(_ urlStr: String) -> Bool {
        return urlStr == Url.universityServiceTimeOut.string() || urlStr == Url.universityServiceTimeOut2.string()
    }

    static func isURLImmediatelyAfterLogin(_ urlStr: String) -> Bool {
        let targetURLs = [Url.skipReminder.string(),
                          Url.courseManagementMobile.string(),
                          Url.courseManagementPC.string()]
        return targetURLs.contains(urlStr)
    }
}
