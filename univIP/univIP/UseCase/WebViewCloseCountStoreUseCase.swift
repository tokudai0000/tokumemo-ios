//
//  WebViewCloseCountStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/24.
//

import Foundation

public protocol WebViewCloseCountStoreUseCaseInterface {
    func fetchWebViewCloseCount() -> Int
    func setWebViewCloseCount(_ items: Int)
}

public struct WebViewCloseCountStoreUseCase: WebViewCloseCountStoreUseCaseInterface {
    private let webViewCloseCountRepository: WebViewCloseCountRepositoryInterface

    public init(
        webViewCloseCountRepository: WebViewCloseCountRepositoryInterface
    ) {
        self.webViewCloseCountRepository = webViewCloseCountRepository
    }

    public func fetchWebViewCloseCount() -> Int {
        return webViewCloseCountRepository.fetchWebViewCloseCount()
    }

    public func setWebViewCloseCount(_ items: Int) {
        webViewCloseCountRepository.setWebViewCloseCount(items)
    }
}
