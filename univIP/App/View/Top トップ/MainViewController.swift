//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit
import EAIntroView

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewGoBackButton: UIButton!
    @IBOutlet weak var webViewGoForwardButton: UIButton!
    @IBOutlet weak var showServiceListsButton: UIButton!
    
    private let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // **DEBUG**
        dataManager.isFinishedMainTutorial = false
        dataManager.isFinishedMenuTutorial = false
        // *********
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !viewModel.hasAgreedTermsOfUse {
            // 規約 未同意者の場合
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        // ////チュートリアル////
        // すでに利用者が40名いるため、初回起動時処理では行わない
        if !dataManager.isFinishedMainTutorial {
            // 未完了の場合
            // ウォークスルーチュートリアル 完了後 -> スポットライトチュートリアル
            walkThroughTutorial()
            // チュートリアル完了とする(以降チュートリアルを表示しない)
            dataManager.isFinishedMainTutorial = true
            return
        }
        if !dataManager.isFinishedMenuTutorial {
            // Mainチュートリアルが終了した後、MenuViewを表示させ、Menuチュートリアルを実行する
            let vc = R.storyboard.menu.menuViewController()!
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - IBAction
    @IBAction func webViewGoBackButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func webViewGoForwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func showServiceListsButton(_ sender: Any) {
        let vc = R.storyboard.menu.menuViewController()!
        vc.delegate = self
        // アニメーションは表示しない
        // トクメモはデザインよりもシンプル、速さを求める(Menuは頻繁に使用すると想定する)
        present(vc, animated: false, completion: nil)
        
    }
    
    
    // MARK: - Public func
    enum ModalViewType {
        case libraryCalendar
        case syllabus
        case cellSort
        case firstViewSetting
        case password
        case aboutThisApp
    }
    public func showModalView(type: ModalViewType) {
        switch type {
            case .libraryCalendar:
                // MARK: - HACK 推奨されたAlertの使い方ではない
                // 常三島と蔵本を選択させるpopup(**Alert**)を表示 **推奨されたAlertの使い方ではない為、修正すべき**
                var alert:UIAlertController!
                //アラートコントローラーを作成する。
                alert = UIAlertController(title: "", message: "図書館の所在を選択", preferredStyle: UIAlertController.Style.alert)
                
                let alertAction = UIAlertAction(
                    title: "常三島",
                    style: UIAlertAction.Style.default,
                    handler: { action in
                        // 常三島のカレンダーURLを取得後、webView読み込み
                        if let url = self.viewModel.fetchLibraryCalendarUrl(type: .main) {
                            self.webView.load(url)
                        }else{
                            AKLog(level: .ERROR, message: "[URL取得エラー]: 常三島開館カレンダー")
                        }
                    })
                
                let alertAction2 = UIAlertAction(
                    title: "蔵本",
                    style: UIAlertAction.Style.default,
                    handler: { action in
                        // 蔵本のカレンダーURLを取得後、webView読み込み
                        if let url = self.viewModel.fetchLibraryCalendarUrl(type: .kura) {
                            self.webView.load(url)
                        }else{
                            AKLog(level: .ERROR, message: "[URL取得エラー]: 蔵本開館カレンダー")
                        }
                    })
                
                //アラートアクションを追加する。
                alert.addAction(alertAction)
                alert.addAction(alertAction2)
                self.present(alert, animated: true, completion:nil)
                
            case .syllabus:
                let vc = R.storyboard.syllabus.syllabusViewController()!
                vc.delegate = self
                present(vc, animated: true, completion: nil)
                
            case .cellSort:
                let vc = R.storyboard.cellSort.cellSort()!
                present(vc, animated: true, completion: nil)
                
            case .firstViewSetting:
                let vc = R.storyboard.firstViewSetting.firstViewSetting()!
                present(vc, animated: true, completion: nil)
                
            case .password:
                let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
                vc.delegate = self
                present(vc, animated: true, completion: nil)
                
                
            case .aboutThisApp:
                let vc = R.storyboard.aboutThisApp.aboutThisApp()!
                present(vc, animated: true, completion: nil)
        }
        
    }
    
    /// シラバス検索ボタンを押された際
    public func refreshSyllabus(subjectName: String, teacherName: String) {
        viewModel.subjectName = subjectName
        viewModel.teacherName = teacherName
        
        let url = URL(string: Url.syllabus.string())! // fatalError
        webView.load(URLRequest(url: url))
    }
    
    
    // MARK: - Private func
    // 教務事務システムのみ、別のログイン方法をとっている？ため、初回に教務事務システムにログインし、キャッシュで別のサイトもログインしていく
    private func login() {
        // 次に読み込まれるURLはJavaScriptを動かすことを許可する(ログイン用)
        dataManager.isExecuteJavascript = true
        
        viewModel.isInitFinishLogin = true
        
        let urlString = Url.universityTransitionLogin.string()
        let url = URL(string: urlString)! // fatalError
        webView.load(URLRequest(url: url))
    }
    

    // ウォークスルーチュートリアル、3枚の画像を表示する
    private func walkThroughTutorial() {
        
        let page1 = EAIntroPage()
        page1.bgImage = UIImage(named: R.image.tutorialImage1.name)
        
        let page2 = EAIntroPage()
        page2.bgImage = UIImage(named: R.image.tutorialImage2.name)
        
        let page3 = EAIntroPage()
        page3.bgImage = UIImage(named: R.image.tutorialImage3.name)
        
        let introView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])
        introView?.delegate = self
        // サイズを調整
        introView?.bgViewContentMode = .scaleAspectFit
        introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal)
        introView?.backgroundColor = UIColor(named: R.color.tokumemoColor.name)
        introView?.show(in: self.view, animateDuration: 0)
        
    }
    
    // スポットライトチュートリアル、showServiceListsButtonにスポットを当てる
    private func tutorialSpotlight() {
        let spotlightViewController = MainTutorialSpotlightViewController()
        // 絶対座標(画面左上X=0,Y=0からの座標)
        let showServiceButtonFrame = showServiceListsButton.convert(showServiceListsButton.bounds, to: self.view)
        // スポットする座標を渡す
        spotlightViewController.uiLabels_frames.append(showServiceButtonFrame)
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
        if !viewModel.isAllowedDomainCheck(url) {
            // 許可外のURLが来た場合は、Safariで開く
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        
        // タイムアウト(20分無操作)の場合
        if url.absoluteString == Url.universityServiceTimeOut.string() {
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
        if viewModel.isFinishLogin(activeUrl) {
            // 初回起動時のログイン
            webView.load(viewModel.searchInitialViewUrl())
        }
        
        // 現在のURLがJavaScript
        switch viewModel.anyJavaScriptExecute(activeUrl) {
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
        
        webViewGoBackButton.isEnabled = webView.canGoBack
        webViewGoBackButton.alpha = webView.canGoBack ? 1.0 : 0.4
        webViewGoForwardButton.isEnabled = webView.canGoForward
        webViewGoForwardButton.alpha = webView.canGoForward ? 1.0 : 0.4
        
    }
    
    
    // alert対応
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default) {
            action in completionHandler()
        }
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action in completionHandler(false)
        }
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    // prompt対応
    // 入力ダイアログ、Alertのtext入力できる版
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        let okHandler: () -> Void = {
            if let textField = alertController.textFields?.first {
                completionHandler(textField.text)
            } else {
                completionHandler("")
            }
        }
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in okHandler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action in completionHandler("")
        }
        alertController.addTextField() { $0.text = defaultText }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}


// MARK: - WKUIDelegate
extension MainViewController: WKUIDelegate {
    // target="_blank"(新しいタブで開く) の処理
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 新しいタブで開くURLを取得し、読み込む
        webView.load(navigationAction.request)
        return nil
    }
}


// MARK: - EAIntroDelegate
extension MainViewController: EAIntroDelegate {
    // ウォークスルーチュートリアルが終了したら呼ばれる
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        // ウォークスルーチュートリアル後、スポットライトチュートリアルを実行する
        tutorialSpotlight()
    }
}
