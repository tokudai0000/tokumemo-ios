//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit
import WebKit
import FirebaseAnalytics

final class WebViewController: UIViewController {
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    // webを表示した時になのをロードするのかを表示下から保持
    public var loadUrlString: String?
    
    private let viewModel = WebViewModel()
    private let dataManager = DataManager.singleton

    private var observation: NSKeyValueObservation?
    private var colorCnt = 0
    private let colorArray: [UIColor] = [
        .blue,
        .green,
        .yellow,
        .red,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 最初は戻るボタンはグレー色にする
        forwardButton.alpha = 0.6
    }
    
    @IBAction func finishButton(_ sender: Any) {
        Analytics.logEvent("WebView[finishButton]", parameters: nil) // Analytics
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        Analytics.logEvent("WebView[backButton]", parameters: nil) // Analytics
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func forwardButton(_ sender: Any) {
        Analytics.logEvent("WebView[forwardButton]", parameters: nil) // Analytics
        webView.goForward()
    }
    
    @IBAction func safariButton(_ sender: Any) {
        Analytics.logEvent("WebView[safariButton]", parameters: nil) // Analytics
        let url = URL(string: viewModel.loadingUrlStr)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        Analytics.logEvent("WebView[reload]", parameters: nil) // Analytics
        webView.reload()
    }
    
    private func initSetup() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true // スワイプで進む、戻るを有効
        
        dataManager.canExecuteJavascript = true
        
        if let urlString = loadUrlString {
            if let url = URL(string: urlString){
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    private func relogin() {
        viewModel.loginFlag(type: .loginFromNow)
        webViewForLogin.load(Url.universityTransitionLogin.urlRequest()) // 大学統合認証システムのログインページを読み込む
    }
    
    private func initProgressSetup() {
        progressView.progressTintColor = colorArray[colorCnt]
        colorCnt = colorCnt + 1
        
        observation = webView.observe(\.estimatedProgress, options: .new){_, change in
            print("progress=\(String(describing: change.newValue))")
            self.progressView.setProgress(Float(change.newValue!), animated: true)
            
            if change.newValue! >= 1.0 {
                UIView.animate(withDuration: 1.0,
                               delay: 0.0,
                               options: [.curveEaseIn],
                               animations: {
                    self.progressView.alpha = 0.0
                    
                }, completion: { (finished: Bool) in
                    self.progressView.progressTintColor = self.colorArray[self.colorCnt]
                    self.colorCnt = self.colorCnt + 1
                    if self.colorCnt >= self.colorArray.count {
                        self.colorCnt = 0
                    }
                    
                    self.progressView.setProgress(0, animated: false)
                })
            }
            else {
                self.progressView.alpha = 1.0
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            AKLog(level: .FATAL, message: "読み込み前のURLがnil")
            decisionHandler(.cancel)
            return
        }
        
        if let component = NSURLComponents(string: url.absoluteString) {
            if let domain = component.host {
                urlLabel.text = domain
            }
        }
        
        // タイムアウトの判定
        if viewModel.isTimeout(urlStr: url.absoluteString) {
            relogin()
        }

        // 問題ない場合読み込みを許可
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 読み込み完了したURL
        let url = self.webView.url! // fatalError
        AKLog(level: .DEBUG, message: url.absoluteString)
        
        viewModel.loadingUrlStr = url.absoluteString // Safari用にデータ保持
        
        // JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
        switch viewModel.anyJavaScriptExecute(url.absoluteString) {
            case .skipReminder:
                // アンケート解答の催促画面
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)

            case .loginIAS:
                // 徳島大学　統合認証システムサイト(ログインサイト)
                // 自動ログインを行う
                webView.evaluateJavaScript("document.getElementById('username').value= '\(dataManager.cAccount)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('password').value= '\(dataManager.password)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
                // フラグを下ろす
                dataManager.canExecuteJavascript = false

            case .syllabus:
                // 検索中は、画面を消すことにより、ユーザーの別操作を防ぐ
                webView.isHidden = true
                
                // シラバスの検索画面
                // ネイティブでの検索内容をWebに反映したのち、検索を行う
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(dataManager.syllabusSubjectName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(dataManager.syllabusTeacherName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
                // フラグを下ろす
                dataManager.canExecuteJavascript = false

            case .loginOutlook:
                // outlook(メール)へのログイン画面
                // cアカウントを登録していなければ自動ログインは効果がないため
                // 自動ログインを行う
                webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(dataManager.cAccount)@tokushima-u.ac.jp'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(dataManager.password)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
                // フラグを下ろす
                dataManager.canExecuteJavascript = false

            case .loginCareerCenter:
                // 徳島大学キャリアセンター室
                // 自動入力を行う(cアカウントは同じ、パスワードは異なる可能性あり)
                // ログインボタンは自動にしない(キャリアセンターと大学パスワードは人によるが同じではないから)
                webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(dataManager.cAccount)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(dataManager.password)'", completionHandler:  nil)
                // フラグを下ろす
                dataManager.canExecuteJavascript = false

            case .none:
                // JavaScriptを動かす必要がなかったURLの場合
                break
        }
        
        // あとでModelに書き直す
        // シラバス検索完了後のURLに変化していたらwebViewを表示
        if url.absoluteString == "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx" {
            webView.isHidden = false
        }
        
        // 戻る、進むボタンの表示を変更
        forwardButton.alpha = webView.canGoForward ? 1.0 : 0.6
    }
    
    /// alert対応
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default) { action in completionHandler() }
        alertController.addAction(otherAction)
        present(alertController, animated: true, completion: nil)
    }
    /// confirm対応
    /// 確認画面、イメージは「この内容で保存しますか？はい・いいえ」のようなもの
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in completionHandler(false) }
        let okAction = UIAlertAction(title: "OK", style: .default) { action in completionHandler(true) }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    /// prompt対応
    /// 入力ダイアログ、Alertのtext入力できる版
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        let okHandler: () -> Void = {
            if let textField = alertController.textFields?.first {
                completionHandler(textField.text)
            }else{
                completionHandler("")
            }
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { action in okHandler() }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in completionHandler("") }
        alertController.addTextField() { $0.text = defaultText }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - WKUIDelegate
extension WebViewController: WKUIDelegate {
    /// target="_blank"(新しいタブで開く) の処理
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 新しいタブで開くURLを取得し、読み込む
        webView.load(navigationAction.request)
        return nil
    }
}
