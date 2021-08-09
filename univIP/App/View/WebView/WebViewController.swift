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
    
    private let acaunt = "c611821006"
    private let pass = "Akidon0326"
    
    let module = Module()
    var displayURL = URL(string: "")
    var passByValue = 0
    var subjectName = ""
    var teacherName = ""
    var keyWord = ""
    
    
    //MARK:- LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        switch passByValue {
        case 0:
            print("error")
        case 1:
            displayURL = module.courceManagementURL
        case 2:
            displayURL = module.manabaURL
        case 3:
            displayURL = module.liburaryURL
        case 11:
            displayURL = module.syllabusURL
        case 12:
            displayURL = module.syllabusURL
        default:
            print("error")
        }
        
        openUrl(url: displayURL!)
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
        
        
        if let url = navigationAction.request.url{
            displayURL = url
            if (module.lostConnectionUrl == url){
                if (module.hasPassdThroughOnce){
//                    let vc = R.storyboard.main.mainViewController()!
                    self.dismiss(animated: true, completion: nil)
//                    self.present(vc, animated: true, completion: nil)
                }
            }
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
        
        
        if (module.hasPassdThroughOnce){
            return
        }
        
        switch passByValue {
        case 0:
            print("error")
        case 1: // 教務事務システム
            webView.evaluateJavaScript("document.getElementById('username').value= 'c611821006'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= 'Akidon0326'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        case 2: // マナバ
            webView.evaluateJavaScript("document.getElementById('username').value= 'c611821006'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= 'Akidon0326'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        case 3: // 図書館
            webView.evaluateJavaScript("document.getElementById('username').value= 'c611821006'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= 'Akidon0326'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        case 11: // シラバス
            print(subjectName)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(subjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(teacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(keyWord)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
            module.hasPassdThroughOnce = true
        case 12: // シラバス詳細
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(subjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(teacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(keyWord)'", completionHandler:  nil)
            module.hasPassdThroughOnce = true
        default:
            print("error")
        }
        
        if (displayURL! == module.courceManagementHomeURL || displayURL! == module.liburaryURL || displayURL! == module.manabaURL){
            module.hasPassdThroughOnce = true
        }
    }
}
