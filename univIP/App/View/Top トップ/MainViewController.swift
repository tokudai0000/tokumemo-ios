//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit
import Gecco
import EAIntroView

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewGoBackButton: UIButton!
    @IBOutlet weak var webViewGoForwardButton: UIButton!
    @IBOutlet weak var showServiceListsButton: UIButton!
    
    private let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    private var spotlightViewController: SpotlightViewController!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // **DEBUGでfalseにしている**
        dataManager.isFinishedMainTutorial = false
        dataManager.isFinishedMenuTutorial = false
        
        refreshWebLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 利用規約同意者か判定
        if viewModel.hasAgreedTermsOfUse {
            // チュートリアルを完了したか判定(すでに利用者が40名いるため、初回起動時ではダメ)
            if !dataManager.isFinishedMainTutorial {
                // 完了していない場合、チュートリアルを表示
                // ウォークスルーチュートリアル 完了後 -> スポットライトチュートリアル
                walkThroughTutorial()
                // チュートリアル完了とする(以降チュートリアルを表示しない)
                dataManager.isFinishedMainTutorial = true
            } else {
                if !dataManager.isFinishedMenuTutorial {
                    let vc = R.storyboard.menu.menuViewController()!
                    self.present(vc, animated: true, completion: nil)
                }
            }

        } else {
            // 利用規約同意画面を表示させる
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
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
        case syllabus
        case cellSort
        case firstViewSetting
        case password
        case aboutThisApp
    }
    public func showModalView(type: ModalViewType) {
        switch type {
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
    
    // 最初に読み込むURLを取得し表示(初期画面)
    private func refreshWebLoad() {
        // フラグを立てる
        dataManager.isExecuteJavascript = true
        webView.load(viewModel.searchInitialViewUrl())
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
        introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal)
        introView?.backgroundColor = UIColor(named: R.color.tokumemoColor.name)
        introView?.show(in: self.view, animateDuration: 0)
        
    }
    
    private func tutorialSpotlight() {
        let spotlightViewController = MainTutorialSpotlightViewController()
        // 絶対座標(画面左上X=0,Y=0からの座標)
        let showServiceButtonFrame = showServiceListsButton.convert(showServiceListsButton.frame, to: self.view)
        print(showServiceButtonFrame)
        // スポットする座標を渡す
        spotlightViewController.uiLabels_frames.append(showServiceButtonFrame)
        present(spotlightViewController, animated: true, completion: nil)
    }
    
}

extension MainViewController: EAIntroDelegate {
    // チュートリアルが終了したら呼ばれる
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        tutorialSpotlight()
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
            refreshWebLoad()
        }
        
        decisionHandler(.allow)
        return
    }
    
    
    // MARK: - 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let activeUrl = self.webView.url! // fatalError
        
        // 現在のURLがJavaScript
        switch viewModel.anyJavaScriptExecute(activeUrl) {
            case .universityLogin:
                // 徳島大学　統合認証システムサイト(ログインサイト)
                // 自動ログインを行う
                webView.evaluateJavaScript("document.getElementById('username').value= '\(DataManager.singleton.cAccount)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('password').value= '\(DataManager.singleton.password)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
                
            case .questionnaireReminder:
                // 教務事務システム、アンケート催促スキップ
                // 「情報システムを使用後直ちに回答を行う」のボタンを自動でクリック
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
                
            case .syllabusFirstTime:
                // シラバスの検索画面
                // ネイティブでの検索内容をWebに反映したのち、検索を行う
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(viewModel.subjectName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(viewModel.teacherName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
                
            case .outlookLogin:
                // outlook(メール)へのログイン画面
                // cアカウントを登録していなければ自動ログインは効果がないため
                // 自動ログインを行う
                webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(dataManager.cAccount)@tokushima-u.ac.jp'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(dataManager.password)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
                
            case .tokudaiCareerCenter:
                // 徳島大学キャリアセンター室
                // 自動入力を行う(cアカウントは同じ、パスワードは異なる可能性あり)
                // ログインボタンは自動にしない(キャリアセンターと大学パスワードは人によるが同じではないから)
                webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(dataManager.cAccount)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(dataManager.password)'", completionHandler:  nil)
                
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
