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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var showMenuButton: UIButton!
    @IBOutlet weak var showFavoriteButton: UIButton!
    
    private let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetup()
        
        #if DEBUG
            dataManager.shouldShowTutorial = true
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 利用規約同意画面を表示するべきか
        if viewModel.shouldDisplayTermsAgreementView {
            // 利用規約同意画面を表示
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        // チュートリアルを表示するべきか
        if dataManager.shouldShowTutorial {
            // チュートリアルを表示
            showTutorial()
            return
        }
    }
    
    // MARK: - IBAction
    @IBAction func backButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func forwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func showFavoriteButton(_ sender: Any) {
        // お気に入り画面の表示
        let vc = R.storyboard.favorite.favoriteViewController()!
        vc.urlString = viewModel.urlString
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showMenuButton(_ sender: Any) {
        // メニューを表示
        let vc = R.storyboard.menu.menuViewController()!
        vc.delegate = self
        present(vc, animated: false, completion: nil) // アニメーションは表示しない(快適性の向上)
    }
    
    // MARK: - Public func
    /// シラバス検索ボタンを押された際
    /// - Parameters:
    ///   - subjectName: <#subjectName description#>
    ///   - teacherName: <#teacherName description#>
    public func loadSyllabusPage(subjectName: String, teacherName: String) {
        viewModel.subjectName = subjectName
        viewModel.teacherName = teacherName
        
        let url = URL(string: Url.syllabus.string())! // fatalError
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - Private func
    /// WKWebViewのDelegateとフォアグラウンド等の設定
    private func initSetup() {
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
        //
        loadLoginPage()
    }
    @objc private func foreground(notification: Notification) {
        // 最後にアプリ画面を離脱した時刻から、一定時間以上経っていれば再ログイン処理を行う
        if viewModel.canExecuteLogin() {
            loadLoginPage()
        }
    }
    @objc private func background(notification: Notification) {
        // 最後にアプリ画面を離脱した時刻を保存
        viewModel.saveTimeUsedLastTime()
    }
    
    /// 教務事務システムのみ、別のログイン方法をとっている？ため、初回に教務事務システムにログインし、キャッシュで別のサイトもログインしていく
    private func loadLoginPage() {
        // ログイン用
        dataManager.isExecuteJavascript = true
        
        let urlString = Url.universityTransitionLogin.string()
        let url = URL(string: urlString)! // fatalError
        webView.load(URLRequest(url: url))
    }
    
    /// スポットライトチュートリアル、showServiceListsButtonにスポットを当てる
    /// お気に入りボタンの説明 -> メニュー画面の説明 -> メニュー画面へ遷移
    /// お気に入り画面とメニュー画面について
    /// スポットする座標を渡す
    /// 表示するテキストを渡す
    private func showTutorial() {
        let vc = MainTutorialSpotlightViewController()
        
        do { // 1. お気に入り画面
            let frame = showFavoriteButton.convert(showFavoriteButton.bounds, to: self.view)
            // 絶対座標(画面左上X=0,Y=0からの座標)を追加する
            vc.uiLabels_frames.append(frame)
            // 表示テキストを追加する
            vc.textLabels.append("お気に入りの画面を記録し\nメニューに表示できるようにします")
        }
        
        do { // 2. メニュー画面
            let frame = showMenuButton.convert(showMenuButton.bounds, to: self.view)
            vc.uiLabels_frames.append(frame)
            vc.textLabels.append("ここからメニューを\n表示できます")
        }
        
        vc.mainViewController = self
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {
    
    /// Description
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
            loadLoginPage()
        }
        
        // 問題ない場合読み込みを許可
        decisionHandler(.allow)
        return
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 現在表示中のURL
        let url = self.webView.url! // fatalError
        
        // アンケート催促画面(教務事務表示前に出現) ログイン失敗等の対策が必要なく、ログインの時点でisExecuteJavascriptがfalseになってしまうから
        // 4行下のコードよりも先に実行
        if viewModel.shouldDisplayInitialWebPage(url.absoluteString) {
            // フラグを立てる
            dataManager.isExecuteJavascript = true
            // 初回起動時のログイン
            webView.load(viewModel.searchInitialViewUrl())
        }
        
        // 現在のURLがJavaScript
        switch viewModel.anyJavaScriptExecute(url.absoluteString) {
            case .universityLogin:
                // 徳島大学　統合認証システムサイト(ログインサイト)
                // 自動ログインを行う
                webView.evaluateJavaScript("document.getElementById('username').value= '\(DataManager.singleton.cAccount)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('password').value= '\(DataManager.singleton.password)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
                // フラグを下ろす
                dataManager.isExecuteJavascript = false
                // ログイン処理中であるフラグを立てる
                viewModel.isLoginProcessing = true
                
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
        backButton.isEnabled = webView.canGoBack
        backButton.alpha = webView.canGoBack ? 1.0 : 0.4
        forwardButton.isEnabled = webView.canGoForward
        forwardButton.alpha = webView.canGoForward ? 1.0 : 0.4
        
        // アナリティクスを送信
        viewModel.analytics(url.absoluteString)
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
