//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit
import FirebaseAnalytics

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var showMenuButton: UIButton!
    @IBOutlet weak var showFavoriteButton: UIButton!
    
    public let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetup()
        
        #if DEBUG
        //dataManager.hadDoneTutorial = false
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 利用規約同意画面を表示するべきか
        if viewModel.shouldShowTermsAgreementView {
            // 利用規約同意画面を表示
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        // チュートリアルを完了していない場合
        if dataManager.hadDoneTutorial == false {
            // チュートリアルを表示
            showTutorial()
            return
        }
        
        // パスワードを登録していないユーザー
        if viewModel.hasRegisteredPassword == false {
            // パスワード入力画面の表示
            let vc = R.storyboard.password.passwordViewController()!
            present(vc, animated: true, completion: {
                // おしらせアラートを表示
                vc.makeLibrarySelector()
            })
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
        // JavaScriptを実行するフラグがを立てる(ユーザーがタイムアウト等をリロードしている可能性があるから)
        dataManager.canExecuteJavascript = true
        // メニューを表示
        let vc = R.storyboard.menu.menuViewController()!
        vc.mainViewController = self
        present(vc, animated: false, completion: nil) // アニメーションは表示しない(快適性の向上)
    }
    
    // MARK: - Private func
    /// MainViewControllerの初期セットアップ
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
        // ログインページの読み込み
        loadLoginPage()
    }
    /// フォアグラウンド時の処理
    @objc private func foreground(notification: Notification) {
        // 最後にアプリ画面を離脱した時刻から、一定時間以上経っていれば再ログイン処理を行う
        if viewModel.isExecuteLogin() {
            loadLoginPage()
        }
    }
    /// バックグラウンド時の処理
    @objc private func background(notification: Notification) {
        // 最後にアプリ画面を離脱した時刻を保存
        viewModel.saveCurrentTime()
    }
    
    /// 大学統合認証システム(IAS)のページを読み込む
    ///
    /// ログインの処理はWebViewのdidFinishで行う
    private func loadLoginPage() {
        // ログイン用
        dataManager.canExecuteJavascript = true
        // ログイン処理中であるフラグを立てる
        viewModel.isLoginProcessing = true
        // 大学統合認証システムのページを読み込む
        webView.load(Url.universityTransitionLogin.urlRequest())
    }
    
    /// チュートリアルを表示する
    ///
    /// 以下の順でボタンを疑似スポットライトをテキストと共に表示させる
    ///  1. お気に入りボタン
    ///  2. メニューボタン
    /// 画面をタップすることで次のスポットライト座標へ遷移し、
    /// メニューボタンの次はメニュー画面を表示させる
    private func showTutorial() {
        let vc = MainTutorialViewController()
        
        do { // 1. お気に入りボタン
            // 絶対座標(画面左上X=0,Y=0からの座標)を取得
            let frame = showFavoriteButton.convert(showFavoriteButton.bounds, to: self.view)
            // スポットライトで照らす座標を追加する
            vc.uiLabels_frames.append(frame)
            // 表示テキストを追加する
            vc.textLabels.append("お気に入りの画面を登録し\nメニューに表示しよう")
        }
        
        do { // 2. メニューボタン
            let frame = showMenuButton.convert(showMenuButton.bounds, to: self.view)
            vc.uiLabels_frames.append(frame)
            vc.textLabels.append("メニューを表示しよう")
        }
        // メニューボタンをスポットした後、メニュー画面を表示させる為に
        // インスタンス(のアドレス)を渡す
        vc.mainViewController = self
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {
    /// 読み込み設定（リクエスト前）
    ///
    /// 以下2つの状態であったら読み込みを開始する。
    ///  1. 読み込み前のURLがnilでないこと
    ///  2. 許可されたドメインであること
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 読み込み前のURLをアンラップ
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        let urlString = url.absoluteString
        
        // 許可されたドメインか判定
        if viewModel.isAllowedDomainCheck(url) == false {
            // 許可外のURLが来た場合は、Safariで開く
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        
        // お気に入り画面のためにURLを保持
        viewModel.urlString = urlString
        
        // タイムアウトした場合
        if viewModel.isTimeout(urlString) {
            // ログイン処理を始める
            loadLoginPage()
        }
        
        // 問題ない場合読み込みを許可
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    ///
    /// 主に以下2つのことを処理する
    ///  1. 大学統合認証システムのログイン処理が終了した場合、ユーザが設定した初期画面を読み込む
    ///  2. JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 読み込み完了したURL
        let url = self.webView.url! // fatalError
        let urlString = url.absoluteString
        
        // 大学統合認証システムのログイン処理が終了した場合
        if viewModel.isLoggedin(urlString) {
            // 初期設定画面がメール(Outlook)の場合用
            dataManager.canExecuteJavascript = true
            // ユーザが設定した初期画面を読み込む
            webView.load(viewModel.searchInitPageUrl())
            return
        }
        
        // JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
        switch viewModel.anyJavaScriptExecute(urlString) {
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
                // シラバスの検索画面
                // ネイティブでの検索内容をWebに反映したのち、検索を行う
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(viewModel.subjectName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(viewModel.teacherName)'", completionHandler:  nil)
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
        
        // 戻る、進むボタンの表示を変更
        backButton.isEnabled = webView.canGoBack
        backButton.alpha = webView.canGoBack ? 1.0 : 0.4
        forwardButton.isEnabled = webView.canGoForward
        forwardButton.alpha = webView.canGoForward ? 1.0 : 0.4
        
        // アナリティクスを送信
        Analytics.logEvent("WebViewReload", parameters: ["pages": urlString]) // Analytics
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
extension MainViewController: WKUIDelegate {
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
