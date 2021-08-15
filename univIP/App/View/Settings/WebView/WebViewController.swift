//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//


/*
 JavaScript 要素取得方法
 https://qiita.com/amamamaou/items/25e8b4e1b41c8d3211f4
 */


import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate, UITabBarDelegate {
    //MARK:- @IBOutlet
    @IBOutlet weak var tabBarUnder: UITabBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var viewTop: UIView!
    
    private let module = Module()
    var url = ""
    
    //MARK:- LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
//        webView.isHidden = true
        
        openUrl(urlString: url)
        restoreView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUnder.delegate = self
        webView.navigationDelegate = self
    }
    
    
    //MARK:- @IBAction
    @IBAction func settingsButton(_ sender: Any) {
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.5,
            delay: 0.08,
            options: .curveEaseOut,
            animations: {
                self.viewTop.layer.position.x += 250
        },
            completion: { bool in
        })
        let vc = R.storyboard.settings.settingsViewController()!
        self.present(vc, animated: false, completion: nil)
//        vc.delegate = self // restoreViewをSettingsVCから呼び出させるため
    }
    
    
    //MARK:- Librari
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            openUrl(urlString: module.courceManagementHomeURL)
        case 2:
            openUrl(urlString: module.manabaURL)
        default:
            return
        }
    }
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url!)
        
        // 現在表示してるURL
        if let url = navigationAction.request.url{
            module.displayURL = url.absoluteString
        }
        decisionHandler(.allow)
    }
    
    /// 読み込み設定（レスポンス取得後）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow) // **必要**
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let cAcaunt = "c611821006" //dataManager.cAccount
        let passWord = "Akidon0326" //dataManager.passWord
        
        if (module.hasPassdThroughOnce){
            webView.isHidden = false
        }
        
        if (module.displayURL.prefix(82) == "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution"){
            module.hasPassdThroughOnce = true
            webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        }
        
        if (module.displayURL == "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"){
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
            webView.isHidden = false
        }
    }
    
    
    // MARK: - Public func
    public func restoreView(){
        // メニューの位置を取得する
        let menuPos = self.viewTop.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.viewTop.layer.position.x = self.viewTop.frame.width
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.viewTop.layer.position.x = menuPos.x
        },
            completion: { bool in
        })
    }
    
    
    // MARK: - Private func
    /// 文字列で指定されたURLをWeb Viewを開く
    private func openUrl(urlString: String) {
        let request = NSURLRequest(url: URL(string:urlString)!)
        webView.load(request as URLRequest)
    }
}


