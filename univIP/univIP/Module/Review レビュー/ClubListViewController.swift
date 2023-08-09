//
//  ClubListViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import WebKit

class ClubListViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setStatusBarBackgroundColor(UIColor(red: 13/255, green: 58/255, blue: 151/255, alpha: 1.0))
        // Web側(JavaScript)からtokumemoPlus関数が送られてくるのを受け取る設定
        webView.configuration.userContentController.add(self, name: "tokumemoPlus")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.load(Url.clubList.urlRequest())
    }
}

extension ClubListViewController: WKNavigationDelegate, WKScriptMessageHandler {
    
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
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = (message.body as? String)!
        present(vc, animated: true, completion: nil)
    }
}
