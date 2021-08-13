//
//  ManabaViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/13.
//

import UIKit
import WebKit

class ManabaViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate, UITabBarDelegate {
    //MARK:- @IBOutlet
    @IBOutlet weak var tabBarUnder: UITabBar!
    @IBOutlet weak var webView: WKWebView!
    
    private let module = Module()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUnder.delegate = self
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        
//        openUrl(url: module.manabaURL!)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        switch item.tag {
//        case 1:
////            openUrl(url: module.courceManagementURL!)
//            let vc = R.storyboard.cM.cmViewController()!
//            self.present(vc, animated: true, completion: nil)
//        case 2:
////            openUrl(url: module.manabaURL!)
////        default:
//            return
//        }
        
    }
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url!)
        
        // 現在表示してるURL
        if let url = navigationAction.request.url{
//            module.displayURL = url
//            if (module.lostConnectionUrl == url){
//                if (module.hasPassdThroughOnce){ // 接続切れの時、ホームへ戻る
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
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
        
        
        let cAcaunt = "c611821006"//dataManager.cAccount
        let passWord = "Akidon0326"//dataManager.passWord
        
//        if (module.displayURL == URL(string: "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1")){
//            webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
//            webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
//            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
//        }
//        if (module.displayURL == URL(string: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx")){
//            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
//        }
//
//        if (module.displayURL == URL(string: "https://manaba.lms.tokushima-u.ac.jp/s/home_summary")){
//
//        }
    }
    
    // MARK: - Private func
    /// 文字列で指定されたURLをWeb Viewを開く
    private func openUrl(url: URL) {
        let request = NSURLRequest(url: url)
        webView.load(request as URLRequest)
    }
}
