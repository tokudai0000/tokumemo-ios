//
//  WebViewCloseCountRepository.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/24.
//

import Foundation

protocol WebViewCloseCountRepositoryInterface {
    func fetchWebViewCloseCount() -> Int
    func setWebViewCloseCount(_ items: Int)
}

final class WebViewCloseCountRepository: WebViewCloseCountRepositoryInterface {
    public init() {}
    
    private var userDefaults = UserDefaults.standard
    private let KEY_webViewCloseCount = "KEY_webViewCloseCount"
    func fetchWebViewCloseCount() -> Int {
        return userDefaults.integer(forKey: KEY_webViewCloseCount)
    }

    func setWebViewCloseCount(_ items: Int) {
        userDefaults.set(items ,forKey: KEY_webViewCloseCount)
    }
}
