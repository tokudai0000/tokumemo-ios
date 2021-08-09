//
//  LibraryViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit
import WebKit

import WebViewJavascriptBridge

class LibraryViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
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
    
    
    private let loginURL = "https://opac.lib.tokushima-u.ac.jp/opac/user/top" // 図書館URL
    
    private var bridge:WebViewJavascriptBridge?
    private var beginingPoint: CGPoint!
    private var isViewShowed: Bool!
    
    private let acaunt = "c611821006"
    private let pass = "Akidon0326"
//    let pass_by_value
    
    
    //MARK:- LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        openUrl(urlString: loginURL)
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
        let vc = R.storyboard.main.mainViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func itemButton(_ sender: Any) {
        toolBar.isHidden = true
    }
    
    
    // MARK: - Private func
    // 文字列で指定されたURLをWeb Viewを開く
    private func openUrl(urlString: String) {
        let url = URL(string: urlString)
        let request = NSURLRequest(url: url!)
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
        
        let url = navigationAction.request.url
        let lostConnectionUrl = URL(string : "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1")
        
        // 接続切れの際、再リロード
        if (url == lostConnectionUrl){
            openUrl(urlString: loginURL)
        }
        print("URL: ", url ?? "")
        
        
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
        
        // ID,PASS入力後ボタンをクリック
        webView.evaluateJavaScript("document.getElementById('username').value= 'c611821006'", completionHandler:  nil)
        webView.evaluateJavaScript("document.getElementById('password').value= 'Akidon0326'", completionHandler:  nil)
        webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
    }
}
