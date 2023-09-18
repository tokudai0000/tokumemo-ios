//
//  ClubListsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import WebKit

class ClubListsViewController: UIViewController {
    private var webView = WKWebView()

    var viewModel: ClubListsViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDefault()
    }
}

// MARK: Layout
private extension ClubListsViewController {
    private func configureView() {
        view.backgroundColor = .white

        let autolayout = view.northLayoutFormat([:], [
            "webView": webView
        ])
        autolayout("H:|-[webView]-|")
        autolayout("V:|-[webView]-|")
    }

    func configureDefault() {
        // Web側(JavaScript)からtokumemoPlus関数が送られてくるのを受け取る設定
        webView.configuration.userContentController.add(self, name: "tokumemoPlus")
        webView.load(Url.clubLists.urlRequest())
    }
}

extension ClubListsViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        return
    }
    
    /// Web側(JavaScript)から値渡し
    /// postMessageを受けとり、表示する
    /// window.webkit.messageHandlers.tokumemoPlus.postMessage(url)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let urlStr = message.body as? String {
            viewModel.input.didTapWebLink.accept(urlStr)
        }
    }
}
