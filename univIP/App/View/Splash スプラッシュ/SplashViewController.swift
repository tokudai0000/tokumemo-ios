//
//  SplashViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/04/06.
//

import UIKit
import WebKit

class SplashViewController: UIViewController, WKNavigationDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    let viewModel = SplashViewModel()
    let dataManager = DataManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewActivityIndicator.startAnimating()
        
        stateLabel.text = "ログイン中"
        relogin()
        // webViewForLogin
        webView.navigationDelegate = self
        dataManager.canExecuteJavascript = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.isTermsOfServiceAgreementNeeded() {
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        if viewModel.isWebLoginRequired() {
            relogin() // 大学サイトへのログイン状況がタイムアウトになってるから
        }
        
//        adImagesRotationTimerON()
        
//        viewModel.getPRItems()
//        viewModel.getWether()
    }
    
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    func relogin() {
        webView.load(Url.universityTransitionLogin.urlRequest())
    }
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            AKLog(level: .FATAL, message: "読み込み前のURLがnil")
            decisionHandler(.cancel)
            return
        }
        
        // ログインが完了しているか
        viewModel.checkLoginComplete(url.absoluteString)

        if viewModel.hasRegisteredPassword() == false {
            viewModel.updateLoginFlag(type: .notStart)
        }

        // タイムアウトの判定
        if viewModel.isTimeout(urlStr: url.absoluteString) {
            relogin()
        }

        // ログインに失敗していた場合、通知
        if viewModel.isLoginFailure(url.absoluteString) {
            viewModel.updateLoginFlag(type: .loginFailure)
//            toast(message: "学生番号もしくはパスワードが間違っている為、ログインできませんでした")
        }
        
        // ログイン完了時に鍵マークを外す(画像更新)為に、collectionViewのCellデータを更新
        if dataManager.loginState.completeImmediately {
            let vc = R.storyboard.main.mainViewController()!
            present(vc, animated: false, completion: nil)
        }
        
        if dataManager.loginState.isProgress == false {
//            viewActivityIndicator.stopAnimating() // クルクルストップ
//            loginGrayBackGroundView.isHidden = true
        }
        
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let url = self.webView.url! // fatalError
        AKLog(level: .DEBUG, message: url.absoluteString)
        print(url.absoluteString)
        
        // JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
        if viewModel.canExecuteJS(url.absoluteString) {
            // 徳島大学　統合認証システムサイト(ログインサイト)に自動ログインを行う。JavaScriptInjection
            webView.evaluateJavaScript("document.getElementById('username').value= '\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)

            // フラグ管理
            viewModel.updateLoginFlag(type: .executedJavaScript)
            return
        }
    }
}
