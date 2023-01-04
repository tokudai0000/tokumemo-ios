//
//  ReviewViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import StoreKit
import WebKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.configuration.userContentController.add(self, name: "test1")
        
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(UIColor(red: 13/255, green: 58/255, blue: 151/255, alpha: 1.0))
    }
    
    /// 画面が表示される直前
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.load(Url.clubList.urlRequest())
    }
    
    // ステータスバーのスタイルを白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
//        switch item.tag {
//            case 1:
//              println("foo")
//            default:
//              println("bar")
//        }
//    }
    
}

// MARK: - WebView
extension ReviewViewController: WKNavigationDelegate, WKScriptMessageHandler {
    // ログイン用に使用するWebViewについての設定
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard navigationAction.request.url != nil else {
            AKLog(level: .FATAL, message: "読み込み前のURLがnil")
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
    }
    
    /// Web側(JavaScript)から値渡し
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = message.body as? String
        present(vc, animated: true, completion: nil)
    }
}
