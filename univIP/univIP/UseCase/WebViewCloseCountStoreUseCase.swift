//
//  WebViewCloseCountStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/24.
//

import Foundation
import Repository

protocol WebViewCloseCountStoreUseCaseInterface {
    func fetchWebViewCloseCount() -> Int
    func setWebViewCloseCount(_ items: Int)
}

struct WebViewCloseCountStoreUseCase: WebViewCloseCountStoreUseCaseInterface {
    private let webViewCloseCountRepository: WebViewCloseCountRepositoryInterface

    init(
        webViewCloseCountRepository: WebViewCloseCountRepositoryInterface
    ) {
        self.webViewCloseCountRepository = webViewCloseCountRepository
    }

    func fetchWebViewCloseCount() -> Int {
        return webViewCloseCountRepository.fetchWebViewCloseCount()
    }

    func setWebViewCloseCount(_ items: Int) {
        webViewCloseCountRepository.setWebViewCloseCount(items)
    }
}
