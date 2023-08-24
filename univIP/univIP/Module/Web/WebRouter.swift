//
//  WebRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/05.
//

import Foundation
import UIKit

enum WebNavigationDestination {
    case goWeb
    case close
}

protocol WebRouterInterface {
    func navigate(_ destination: WebNavigationDestination)
}

final class WebRouter: BaseRouter, WebRouterInterface {
    init(loadUrl: URLRequest) {
        let viewController = R.storyboard.web.webViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = WebViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                             loadUrl: loadUrl,
                              univAuthStoreUseCase: UnivAuthStoreUseCase(
                                univAuthRepository: UnivAuthOnKeyChainRepository()
                              ),
                              webViewCloseCountStoreUseCase: WebViewCloseCountStoreUseCase(
                                webViewCloseCountRepository: WebViewCloseCountRepository()
                              )
                             )
        )
    }

    func navigate(_ destination: WebNavigationDestination) {
        switch destination {
        case .goWeb:
            moduleViewController.navigationController?.popViewController(animated: true)
        case .close:
            moduleViewController.dismiss(animated: true)
        }
    }
}
