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


class WebViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    //MARK:- @IBOutlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!{
        didSet {
            backButton.isEnabled = false
            backButton.tintColor = UIColor.blue.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var forwardButton: UIBarButtonItem! {
        didSet {
            forwardButton.isEnabled = false
            forwardButton.tintColor = UIColor.blue.withAlphaComponent(0.4)
        }
    }
    
    private let module = Module()
    private var beginingPoint: CGPoint!
    private var isViewShowed: Bool!

    // buttonTagの値が送られる
    var buttonTagValue = 0
    // Syllabusから値が送られる
    var subjectName = ""
    var teacherName = ""
    var keyWord = ""
    
    /// keyChain
    private var dataManager = DataManager()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // 初回時、webViewを非表示
        if (module.hasPassdCounter == 0){
            webView.isHidden = true
        }
        
        switch buttonTagValue {
        case 0:
            print("error")
        case 1:
            module.displayURL = module.courceManagementURL
        case 2:
            module.displayURL = module.manabaURL
        case 3:
            module.displayURL = module.liburaryURL
        case 11:
            module.displayURL = module.syllabusURL
        case 12:
            module.displayURL = module.syllabusURL
        default:
            print("error")
        }
        
        openUrl(url: module.displayURL!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        
        beginingPoint = CGPoint(x: 0, y: 0)
        isViewShowed = true
    }
    
    
    //MARK:- @IBAction
    @IBAction func goBackButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func goForwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Library
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginingPoint = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPoint = scrollView.contentOffset
        let contentSize = scrollView.contentSize
        let frameSize = scrollView.frame
        let maxOffset = contentSize.height - frameSize.height
        
        if currentPoint.y >= maxOffset {
            //             print("hit the bottom")
        } else if beginingPoint.y + 100 < currentPoint.y {
            toolBar.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            toolBar.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // 現在表示してるURL
        if let url = navigationAction.request.url{
            module.displayURL = url
            if (module.lostConnectionUrl == url){
                if (module.hasPassdThroughOnce){ // 接続切れの時、ホームへ戻る
                    self.dismiss(animated: true, completion: nil)
                }
            }
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
        DispatchQueue.main.async {
            // 戻るボタン、進むボタンが機能できるか
            self.backButton.isEnabled = webView.canGoBack
            self.backButton.tintColor = UIColor.blue.withAlphaComponent(webView.canGoBack ? 1.0 : 0.4)
            self.forwardButton.isEnabled = webView.canGoForward
            self.forwardButton.tintColor = UIColor.blue.withAlphaComponent(webView.canGoBack ? 1.0 : 0.4)
        }
        
        // 4回(教務事務システムのclickに時間がかかる)もしくは、正常にURL遷移できた場合、画面を表示
        if (module.hasPassdCounter >= 4 || module.displayURL == module.confirmationURL){
            webView.isHidden = false
            return
        }
        
        let cAcaunt = dataManager.cAccount
        let passWord = dataManager.passWord
        // 1回目
        switch buttonTagValue {
        case 1, 2, 3: // 教務事務システム, マナバ, 図書館
            webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        case 11, 12: // シラバス, シラバス詳細
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(subjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(teacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(keyWord)'", completionHandler:  nil)
            module.hasPassdCounter = 100
            module.confirmationURL = module.syllabusURL
        default:
            print("error: WebView.webView1")
        }
        // 2回目
        switch buttonTagValue {
        case 1: // 教務事務システム
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
            module.confirmationURL = module.courceManagementHomeURL
        case 2: // マナバ
            module.confirmationURL = module.manabaURL
        case 3: // 図書館
            module.confirmationURL = module.liburaryURL
        case 11: // シラバス
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
        case 12: // シラバス詳細
            webView.isHidden = false
        default:
            print("error: WebView.webView1")
        }
        
        if (module.displayURL! == module.courceManagementHomeURL || module.displayURL! == module.liburaryURL || module.displayURL! == module.manabaURL){
            webView.isHidden = false
            return
        }
        module.hasPassdCounter += 1
    }
    
    // MARK: - Private func
    /// 文字列で指定されたURLをWeb Viewを開く
    private func openUrl(url: URL) {
        let request = NSURLRequest(url: url)
        webView.load(request as URLRequest)
    }

}
