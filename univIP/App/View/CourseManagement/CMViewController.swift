//
//  CMViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/06.
//

import UIKit
import WebKit

import WebViewJavascriptBridge

// https://qiita.com/beaa/items/cfb80790d333c2da252b
// javascriptinjection WKNavigationDelegate
class CMViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    
    
    @IBAction func goBackButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func goForwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    var bridge:WebViewJavascriptBridge?
    
     @IBAction func homeButton(_ sender: Any) {
         let vc = R.storyboard.main.mainViewController()!
         self.present(vc, animated: true, completion: nil)
     }
    
    
    let loginURL = "https://eweb.stud.tokushima-u.ac.jp/Portal"
//    let loginURL = "https://google.com"
    
    let acaunt = "c611821006"
    let pass = "Akidon0326"
    //id username
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        openUrl(urlString: loginURL)
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.evaluateJavaScript("coordinateButton();", completionHandler: nil)
        
        
        
    }
    
    // 文字列で指定されたURLをWeb Viewを開く
    func openUrl(urlString: String) {
        let url = URL(string: urlString)
        let request = NSURLRequest(url: url!)
        webView.load(request as URLRequest)
    }
    
    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("リクエスト前")
        
        /*
         * WebView内の特定のリンクをタップした時の処理などが書ける(2019/11/16追記)
         */
        let url = navigationAction.request.url
//        let url2 = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1"
        print("読み込もうとしているページのURLが取得できる: ", url ?? "")
        print(type(of: url))
        
//        if url2 == String(url!) {
//            //ログイン記入
//        }
        
        // リンクをタップしてページを読み込む前に呼ばれるので、例えば、urlをチェックして
        // ①AppStoreのリンクだったらストアに飛ばす
        // ②Deeplinkだったらアプリに戻る
        // みたいなことができる
        
        /*  これを設定しないとアプリがクラッシュする
         *  .allow  : 読み込み許可
         *  .cancel : 読み込みキャンセル
         */
        decisionHandler(.allow)
    }
    
    // MARK: - 読み込み準備開始
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("読み込み準備開始")
    }
    
    // MARK: - 読み込み設定（レスポンス取得後）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("レスポンス取得後")
        
        /*  これを設定しないとアプリがクラッシュする
         *  .allow  : 読み込み許可
         *  .cancel : 読み込みキャンセル
         */
        decisionHandler(.allow)
        // 注意：受け取るレスポンスはページを読み込みタイミングのみで、Webページでの操作後の値などは受け取れない
    }
    
    // MARK: - 読み込み開始
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("読み込み開始")
    }
    
    // MARK: - ユーザ認証（このメソッドを呼ばないと認証してくれない）
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("ユーザ認証")
        completionHandler(.useCredential, nil)
    }
    
    // MARK: - 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("読み込み完了")
    }
    
    // MARK: - 読み込み失敗検知
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗検知")
    }
    
    // MARK: - 読み込み失敗
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗")
    }
    
    // MARK: - リダイレクト
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation:WKNavigation!) {
        print("リダイレクト")
    }
    
}
