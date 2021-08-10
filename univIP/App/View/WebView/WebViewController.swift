//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit
import WebKit

import WebViewJavascriptBridge

// https://qiita.com/beaa/items/cfb80790d333c2da252b
// javascriptinjection WKNavigationDelegate
// https://qiita.com/amamamaou/items/25e8b4e1b41c8d3211f4

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
    
    
    private var bridge:WebViewJavascriptBridge?
    private var beginingPoint: CGPoint!
    private var isViewShowed: Bool!

    
    let module = Module()
//    var module.displayURL = URL(string: "")
    var passByValue = 0
    var subjectName = ""
    var teacherName = ""
    var keyWord = ""
    var dataManager = DataManager()
    
    
    //MARK:- LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if (module.hasPassdCounter == 0){
            webView.isHidden = true
        }
        
        switch passByValue {
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
//        webView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginingPoint = CGPoint(x: 0, y: 0)
        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        isViewShowed = true
        // 読み込み中のインジケータの表示
        //        setUpProgressView()
        // 横ワイプのジェスチャーで戻れるor進めれる
        //        webView.allowsBackForwardNavigationGestures = true
    }
    
    
    
    //MARK:- @IBAction
    @IBAction func goBackButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func goForwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func homeButton(_ sender: Any) {
//        let vc = R.storyboard.main.mainViewController()!
        self.dismiss(animated: true, completion: nil)
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func itemButton(_ sender: Any) {
        toolBar.isHidden = true
    }
    
    
    // MARK: - Private func
    // 文字列で指定されたURLをWeb Viewを開く
    private func openUrl(url: URL) {
        let request = NSURLRequest(url: url)
        webView.load(request as URLRequest)
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
    
    
    // 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // 接続切れの時、ホームへ戻る
        if let url = navigationAction.request.url{
            module.displayURL = url
            if (module.lostConnectionUrl == url){
                if (module.hasPassdThroughOnce){
                    self.dismiss(animated: true, completion: nil)
                }
            }
//            print("navURL:", navigationAction.request.url)
//            print("disURL:", module.displayURL)
//            print("modURL:", module.confirmationURL)
//            if (module.displayURL == module.confirmationURL){
//                webView.isHidden = false
//            }
        }
        
        
        decisionHandler(.allow)
    }
    
    
    // 読み込み設定（レスポンス取得後）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    // 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.backButton.isEnabled = webView.canGoBack
            self.backButton.tintColor = UIColor.blue.withAlphaComponent(webView.canGoBack ? 1.0 : 0.4)
            self.forwardButton.isEnabled = webView.canGoForward
            self.forwardButton.tintColor = UIColor.blue.withAlphaComponent(webView.canGoBack ? 1.0 : 0.4)
        }
        
        if (module.displayURL == module.confirmationURL){
            webView.isHidden = false
        }
        if (module.hasPassdThroughOnce){
            webView.isHidden = false
            return
        }
        if (module.hasPassdCounter >= 4){
            webView.isHidden = false
            return
        }
        
        // 初回のみ通る
        
        let acaunt = dataManager.cAccount
        let pass = dataManager.passWord
        print("passByValue",passByValue)
        
        switch passByValue {
        case 0:
            print("error")
        case 1: // 教務事務システム
            webView.evaluateJavaScript("document.getElementById('username').value= '\(acaunt)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(pass)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
            module.confirmationURL = module.courceManagementHomeURL
        case 2: // マナバ
            webView.evaluateJavaScript("document.getElementById('username').value= '\(acaunt)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(pass)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            module.confirmationURL = module.manabaURL
        case 3: // 図書館
            webView.evaluateJavaScript("document.getElementById('username').value= '\(acaunt)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(pass)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            module.confirmationURL = module.liburaryURL
        case 11: // シラバス
            print(subjectName)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(subjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(teacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(keyWord)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
            module.hasPassdThroughOnce = true
            module.confirmationURL = module.syllabusURL
        case 12: // シラバス詳細
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(subjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(teacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(keyWord)'", completionHandler:  nil)
            module.hasPassdThroughOnce = true
            module.confirmationURL = module.syllabusURL
            webView.isHidden = false
        default:
            print("error")
        }
        module.hasPassdCounter += 1
        
        if (module.displayURL! == module.courceManagementHomeURL || module.displayURL! == module.liburaryURL || module.displayURL! == module.manabaURL){
            module.hasPassdThroughOnce = true
        }
    }
}
