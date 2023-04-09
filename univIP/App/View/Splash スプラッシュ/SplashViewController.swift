//
//  SplashViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/04/06.
//

import UIKit
import WebKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    let viewModel = SplashViewModel()
    let dataManager = DataManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewActivityIndicator.startAnimating()
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 利用規約に同意する必要があるかどうか
        if viewModel.isTermsOfServiceAgreementNeeded() {
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        // ログイン処理が必要かどうか
        if viewModel.isWebLoginRequired() {
            viewModel.updateLoginFlag(type: .loginStart)
            
            stateLabel.text = "自動ログイン中"
            processReloginForWebPage()
        }
        
        
        viewModel.getWether()
        viewModel.getPRItems()
        
    }
    
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    private func processReloginForWebPage() {
        dataManager.canExecuteJavascript = true
        webView.load(Url.universityTransitionLogin.urlRequest())
    }
    
}

extension SplashViewController: WKNavigationDelegate {
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            AKLog(level: .FATAL, message: "読み込み前のURLがnil")
            decisionHandler(.cancel)
            return
        }
        
        // パスワードを登録しているか
        if viewModel.isPasswordRegistered() == false {
            viewModel.updateLoginFlag(type: .notStart)
        }
        
        // タイムアウトしているか
        if viewModel.isTimeoutOccurredForURL(urlStr: url.absoluteString) {
            viewModel.updateLoginFlag(type: .loginStart)
            
            processReloginForWebPage()
        }
        
        // ログインが完了しているか
        if viewModel.isLoginCompletedForURL(url.absoluteString) {
            viewModel.updateLoginFlag(type: .loginSuccess)
            
            let vc = R.storyboard.main.mainViewController()!
            present(vc, animated: false, completion: nil)
        }

        // ログインに失敗しているか
        if viewModel.isLoginFailedForURL(url.absoluteString) {
            viewModel.updateLoginFlag(type: .loginFailure)
//            toast(message: "学生番号もしくはパスワードが間違っている為、ログインできませんでした")
        }
                
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let url = self.webView.url! // fatalError
        AKLog(level: .DEBUG, message: url.absoluteString)
        
        // JavaScriptを動かしたいURLかどうかを判定
        if viewModel.canRunJavaScriptOnURL(url.absoluteString) {
            viewModel.updateLoginFlag(type: .executedJavaScript)
            
            // 徳島大学　統合認証システムサイト(ログインサイト)に自動ログインを行う。JavaScriptInjection
            webView.evaluateJavaScript("document.getElementById('username').value= '\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            return
        }
    }
}
