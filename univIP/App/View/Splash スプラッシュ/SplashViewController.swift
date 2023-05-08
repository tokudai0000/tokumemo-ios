//
//  SplashViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/04/06.
//

import UIKit
import WebKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var progressStatusLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    private let viewModel = SplashViewModel()
    private let dataManager = DataManager.singleton
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewActivityIndicator.startAnimating()
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        // ログイン処理
        viewModel.updateLoginFlag(type: .loginStart)
        stateLabel.text = "自動ログイン中"
        processReloginForWebPage()
        
        
        viewModel.getPRItems()
        
        // パスワードを登録しているか
        if viewModel.isPasswordRegistered() == false {
            viewModel.updateLoginFlag(type: .notStart)
            
            let vc = R.storyboard.main.mainViewController()!
            present(vc, animated: false, completion: nil)
        }
        
        // ログイン中が一定経過すると自動ログイン失敗と処理する。
        let workItem = DispatchWorkItem {
            self.viewModel.updateLoginFlag(type: .loginFailure)
            let vc = R.storyboard.main.mainViewController()!
            self.present(vc, animated: false, completion: nil)
        }
        // 9秒後にworkItemを実行する
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.0, execute: workItem)
        
        
        // 9秒間を退屈させないために、進行度を表示
        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                     repeats: true,
                                     block: { (timer) in
            if self.viewModel.progressStatus < 100 {
                self.viewModel.progressStatus += 10
                self.progressStatusLabel.text = String(self.viewModel.progressStatus) + " %"
            }else{
                timer.invalidate() //メモリ解放
            }
        })
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
        
        // タイムアウトしているか
        if viewModel.isTimeoutOccurredForURL(urlStr: url.absoluteString) {
            viewModel.updateLoginFlag(type: .loginStart)
            
            stateLabel.text = "再ログイン中"
            processReloginForWebPage()
        }
        
        // ログインが完了しているか
        if viewModel.isLoginCompletedForURL(url.absoluteString) {
            viewModel.updateLoginFlag(type: .loginSuccess)
            
            let vc = R.storyboard.main.mainViewController()!
            present(vc, animated: false, completion: nil)
        }else{
            print(dataManager.loginState.completed)
            print(dataManager.loginState.isProgress)
            print(dataManager.loginState.completeImmediately)
            print("---")
        }
        
        // ログインに失敗しているか
        if viewModel.isLoginFailedForURL(url.absoluteString) {
            viewModel.updateLoginFlag(type: .loginFailure)
            //            toast(message: "学生番号もしくはパスワードが間違っている為、ログインできませんでした")
            let vc = R.storyboard.main.mainViewController()!
            present(vc, animated: false, completion: nil)
        }
        
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let url = self.webView.url! // fatalError
        AKLog(level: .DEBUG, message: url.absoluteString)
        
        // JavaScriptを動かしたいURLか
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
