//
//  WebView.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/02/14.
//

import UIKit
import WebKit

// MARK: - WebView
extension HomeViewController: WKNavigationDelegate {
    // ログイン用に使用するWebViewについての設定
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            AKLog(level: .FATAL, message: "読み込み前のURLがnil")
            viewActivityIndicator.stopAnimating() // クルクルストップ
            loginGrayBackGroundView.isHidden = true
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
            toast(message: "学生番号もしくはパスワードが間違っている為、ログインできませんでした")
        }
        
        // ログイン完了時に鍵マークを外す(画像更新)為に、collectionViewのCellデータを更新
        if viewModel.isLoginCompleteImmediately {
            collectionView.reloadData()
        }
        
        if viewModel.isLoginProcessing == false {
            viewActivityIndicator.stopAnimating() // クルクルストップ
            loginGrayBackGroundView.isHidden = true
        }
        
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let url = self.webViewForLogin.url! // fatalError
        AKLog(level: .DEBUG, message: url.absoluteString)
        
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
