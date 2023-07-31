//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - IBOutlet
    
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
    
    private let colorArray: [UIColor] = [.blue, .green, .yellow, .red,]
    
    private var toastView:UIView?
    private var toastShowFrame:CGRect = .zero
    private var toastHideFrame:CGRect = .zero
    private var toastInterval:TimeInterval = 3.0
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupDelegate()
        if dataManager.cAccount.isEmpty || dataManager.password.isEmpty {
            toast(message: "settingsからパスワード設定すると、自動ログインできますよ♪", interval: 10.0)
            dataManager.canExecuteJavascript = false
        }
        if let urlString = loadUrlString {
            if let url = URL(string: urlString){
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func forwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func safariButton(_ sender: Any) {
        let url = URL(string: viewModel.loadingUrlStr)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func menuButton(_ sender: Any) {
        let vc = R.storyboard.menu.menuViewController()!
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func reloadButton(_ sender: Any) {
        webView.reload()
    }
    
    // MARK: - Methods [Private]
    
    private func setupDefaults() {
        forwardButton.alpha = 0.6
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func setupDelegate() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func setupProgressView() {
        progressView.progressTintColor = colorArray[colorCnt]
        colorCnt = colorCnt + 1
        observation = webView.observe(\.estimatedProgress, options: .new){_, change in
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
    
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    private func relogin() {
        webView.load(Url.universityTransitionLogin.urlRequest())
    }
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    
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
        if viewModel.isTimeout(urlStr: url.absoluteString) {
            relogin()
        }
        if viewModel.shouldOpenSafari(urlStr: url.absoluteString) {
            let url = URL(string: viewModel.loadingUrlStr)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
        return
    }
    
    /*
     JavaScriptをWebサイトごとに実行する
     - アンケート解答の催促画面
     - 徳島大学　統合認証システムサイト(ログインサイト)
     - シラバスの検索画面
     - outlook(メール)へのログイン画面
     - 徳島大学キャリアセンター室
     
     NOTE:
     シラバスでは検索中は、画面を消すことにより、ユーザーの別操作を防ぐ
     キャリアセンター室ではログインボタンは自動にしない(キャリアセンターと大学パスワードは人によるが同じではないから)
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = self.webView.url!
        AKLog(level: .DEBUG, message: url.absoluteString)
        viewModel.loadingUrlStr = url.absoluteString // Safari用にデータ保持
        switch viewModel.anyJavaScriptExecute(url.absoluteString) {
        case .skipReminder:
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        case .loginIAS:
            webView.evaluateJavaScript("document.getElementById('username').value= '\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            dataManager.canExecuteJavascript = false
        case .syllabus:
            webView.isHidden = true
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(dataManager.syllabusSubjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(dataManager.syllabusTeacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
            dataManager.canExecuteJavascript = false
        case .loginOutlook:
            webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(dataManager.cAccount)@tokushima-u.ac.jp'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
            dataManager.canExecuteJavascript = false
        case .loginCareerCenter:
            webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(dataManager.password)'", completionHandler:  nil)
            dataManager.canExecuteJavascript = false
        case .none:
            break
        }
        
        if url.absoluteString == Url.syllabusSearchCompleted.string() {
            webView.isHidden = false
        }
        forwardButton.alpha = webView.canGoForward ? 1.0 : 0.6 // 戻る、進むボタンの表示を変更
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

extension WebViewController {
    
    /// トースト表示
    ///
    /// - Parameters:
    ///   - message: メッセージ
    ///   - interval: 表示時間（秒）デフォルト3秒
    public func toast( message: String, type: String = "highBottom", interval:TimeInterval = 3.0 ) {
        guard self.toastView == nil else {
            return // 既に表示準備中
        }
        self.toastView = UIView()
        guard let toastView = self.toastView else { // アンラッピング
            return
        }
        
        toastInterval = interval
        
        switch type {
        case "top":
            toastShowFrame = CGRect(x: 15,
                                    y: 8,
                                    width: self.view.frame.width - 15 - 15,
                                    height: 46)
            
            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
                                    y: 0 - toastShowFrame.height * 2,  // 上に隠す
                                    width: toastShowFrame.width,
                                    height: toastShowFrame.height)
            
        case "bottom":
            toastShowFrame = CGRect(x: 15,
                                    y: self.view.frame.height - 100,
                                    width: self.view.frame.width - 15 - 15,
                                    height: 46)
            
            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
                                    y: self.view.frame.height - toastShowFrame.height * 2,  // 上に隠す
                                    width: toastShowFrame.width,
                                    height: toastShowFrame.height)
            
        case "highBottom":
            toastShowFrame = CGRect(x: 15,
                                    y: self.view.frame.height - 180,
                                    width: self.view.frame.width - 15 - 15,
                                    height: 46)
            
            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
                                    y: self.view.frame.height - toastShowFrame.height * 2,  // 上に隠す
                                    width: toastShowFrame.width,
                                    height: toastShowFrame.height)
        default:
            return
        }
        toastView.frame = toastHideFrame  // 初期隠す位置
        toastView.backgroundColor = UIColor.black
        toastView.alpha = 0.8
        toastView.layer.cornerRadius = 18
        self.view.addSubview(toastView)
        
        let labelWidth:CGFloat = toastView.frame.width - 14 - 14
        let labelHeight:CGFloat = 19.0
        let label = UILabel()
        // toastView内に配置
        label.frame = CGRect(x: 14,
                             y: 14,
                             width: labelWidth,
                             height: labelHeight)
        toastView.addSubview(label)
        // label属性
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 0 // 複数行対応
        label.text = message
        //"label.frame1: \(label.frame)")
        // 幅を制約して高さを求める
        label.frame.size = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        //print("label.frame2: \(label.frame)")
        // 複数行対応・高さ変化
        if labelHeight < label.frame.height {
            toastShowFrame.size.height += (label.frame.height - labelHeight)
        }
        didHideIndicator()
    }
    @objc private func didHideIndicator() {
        guard let toastView = self.toastView else { // アンラッピング
            return
        }
        DispatchQueue.main.async { // 非同期処理
            UIView.animate(withDuration: 0.5, animations: { () in
                // 出現
                toastView.frame = self.toastShowFrame
            }) { (result) in
                // 出現後、interval(秒)待って、
                DispatchQueue.main.asyncAfter(deadline: .now() + self.toastInterval) {
                    UIView.animate(withDuration: 0.5, animations: { () in
                        // 消去
                        toastView.frame = self.toastHideFrame
                    }) { (result) in
                        // 破棄
                        toastView.removeFromSuperview()
                        self.toastView = nil // 破棄
                    }
                }
            }
        }
    }
}
