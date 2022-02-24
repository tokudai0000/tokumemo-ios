//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewGoBackButton: UIButton!
    @IBOutlet weak var webViewGoForwardButton: UIButton!
    @IBOutlet weak var showServiceListsButton: UIButton!
    
    public let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // WKWebViewのDelegateとフォアグラウンド等の設定
        setUp()
        // 大学サイトへのログイン
        login()
        
        // **DEBUG**
//        dataManager.shouldExecuteTutorial = true
        // *********
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 利用規約同意画面を表示するべきか(利用規約更新に伴い再度呼び出しされる)
        if viewModel.shouldDisplayTermsAgreementView {
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        // チュートリアルを実行するべきか
        if dataManager.shouldExecuteTutorial {
            tutorialSpotlight()
            return
        }
    }
    
    // MARK: - IBAction
    @IBAction func webViewGoBackButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func webViewGoForwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func showFavoriteViewButton(_ sender: Any) {
        let vc = R.storyboard.favorite.favoriteViewController()!
        vc.urlString = viewModel.urlString
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showMenuViewButton(_ sender: Any) {
        let vc = R.storyboard.menu.menuViewController()!
        vc.delegate = self
        // アニメーションは表示しない(Menuは頻繁に使用するから快適性の向上)
        present(vc, animated: false, completion: nil)
    }
    
    // MARK: - Public func
    /// シラバス検索ボタンを押された際
    public func refreshSyllabus(subjectName: String, teacherName: String) {
        viewModel.subjectName = subjectName
        viewModel.teacherName = teacherName
        
        let url = URL(string: Url.syllabus.string())! // fatalError
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - Private func
    /// WKWebViewのDelegateとフォアグラウンド等の設定
    private func setUp() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        // フォアグラウンドの判定
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(foreground(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        // バックグラウンドの判定
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(background(notification:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    @objc private func foreground(notification: Notification) {
        // 最後にアプリ画面を離脱した時刻から、一定時間以上経っていれば再ログイン処理を行う
        if viewModel.shouldExecuteLogin() {
            login()
        }
    }
    @objc private func background(notification: Notification) {
        // 最後にアプリ画面を離脱した時刻を保存
        viewModel.saveTimeUsedLastTime()
    }
    
    /// 教務事務システムのみ、別のログイン方法をとっている？ため、初回に教務事務システムにログインし、キャッシュで別のサイトもログインしていく
    private func login() {
        // 次に読み込まれるURLはJavaScriptを動かすことを許可する(ログイン用)
        dataManager.isExecuteJavascript = true
        // ログイン処理中であるフラグを立てる
        viewModel.isLoginProcessing = true
        
        let urlString = Url.universityTransitionLogin.string()
        let url = URL(string: urlString)! // fatalError
        webView.load(URLRequest(url: url))
    }
    
    // スポットライトチュートリアル、showServiceListsButtonにスポットを当てる
    private func tutorialSpotlight() {
        let spotlightViewController = MainTutorialSpotlightViewController()
        let menuButtonFrame = showServiceListsButton.convert(showServiceListsButton.bounds, to: self.view) // 絶対座標(画面左上X=0,Y=0からの座標)
        spotlightViewController.uiLabels_frames.append(menuButtonFrame) // スポットする座標を渡す
        spotlightViewController.mainViewController = self
        present(spotlightViewController, animated: true, completion: nil)
    }
}

// MARK: - WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {
    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 読み込み中のURLをアンラップ
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        // 読み込み中のURL(ドメイン)が許可されたドメインは判定
        if viewModel.isAllowedDomainCheck(url) == false {
            // 許可外のURLが来た場合は、Safariで開く
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        
        // Favorite画面のためにURLを保持
        viewModel.urlString = url.absoluteString
        
        // タイムアウト(20分無操作)の場合
        if viewModel.isTimeOut(url.absoluteString) {
            login()
        }
        
        decisionHandler(.allow)
        return
    }
    
    // MARK: - 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let activeUrl = self.webView.url! // fatalError
        
        // アンケート催促画面(教務事務表示前に出現) ログイン失敗等の対策が必要なく、ログインの時点でisExecuteJavascriptがfalseになってしまうから
        // 4行下のコードよりも先に実行
        if viewModel.shouldDisplayInitialWebPage(activeUrl.absoluteString) {
            // フラグを立てる
            dataManager.isExecuteJavascript = true
            // 初回起動時のログイン
            webView.load(viewModel.searchInitialViewUrl())
        }
        
        // 現在のURLがJavaScript
        switch viewModel.anyJavaScriptExecute(activeUrl.absoluteString) {
            case .universityLogin:
                // 徳島大学　統合認証システムサイト(ログインサイト)
                // 自動ログインを行う
                webView.evaluateJavaScript("document.getElementById('username').value= '\(DataManager.singleton.cAccount)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('password').value= '\(DataManager.singleton.password)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
                // フラグを下ろす
                dataManager.isExecuteJavascript = false
                
            case .syllabusFirstTime:
                // シラバスの検索画面
                // ネイティブでの検索内容をWebに反映したのち、検索を行う
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(viewModel.subjectName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(viewModel.teacherName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
                // フラグを下ろす
                dataManager.isExecuteJavascript = false
                
            case .outlookLogin:
                // outlook(メール)へのログイン画面
                // cアカウントを登録していなければ自動ログインは効果がないため
                // 自動ログインを行う
                webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(dataManager.cAccount)@tokushima-u.ac.jp'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(dataManager.password)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
                // フラグを下ろす
                dataManager.isExecuteJavascript = false
                
            case .tokudaiCareerCenter:
                // 徳島大学キャリアセンター室
                // 自動入力を行う(cアカウントは同じ、パスワードは異なる可能性あり)
                // ログインボタンは自動にしない(キャリアセンターと大学パスワードは人によるが同じではないから)
                webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(dataManager.cAccount)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(dataManager.password)'", completionHandler:  nil)
                // フラグを下ろす
                dataManager.isExecuteJavascript = false
                
            case .none:
                break
        }
        
        // 戻る、進むボタンの表示を変更
        webViewGoBackButton.isEnabled = webView.canGoBack
        webViewGoBackButton.alpha = webView.canGoBack ? 1.0 : 0.4
        webViewGoForwardButton.isEnabled = webView.canGoForward
        webViewGoForwardButton.alpha = webView.canGoForward ? 1.0 : 0.4
        
        // アナリティクスを送信
        viewModel.analytics(activeUrl.absoluteString)
    }
    
    // alert対応
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default) { action in completionHandler() }
        alertController.addAction(otherAction)
        present(alertController, animated: true, completion: nil)
    }
    // confirm対応
    // 確認画面、イメージは「この内容で保存しますか？はい・いいえ」のようなもの
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
    // prompt対応
    // 入力ダイアログ、Alertのtext入力できる版
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        let okHandler: () -> Void = {
            if let textField = alertController.textFields?.first {
                completionHandler(textField.text)
            } else {
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
extension MainViewController: WKUIDelegate {
    // target="_blank"(新しいタブで開く) の処理
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 新しいタブで開くURLを取得し、読み込む
        webView.load(navigationAction.request)
        return nil
    }
}
