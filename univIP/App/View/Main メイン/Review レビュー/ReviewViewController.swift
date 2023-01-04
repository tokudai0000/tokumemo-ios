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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(Url.clubList.urlRequest())
        
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(UIColor(red: 13/255, green: 58/255, blue: 151/255, alpha: 1.0))
    }
    
    // ステータスバーのスタイルを白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
}

// MARK: - WebView
extension ReviewViewController: WKNavigationDelegate {
    // ログイン用に使用するWebViewについての設定
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
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
}
