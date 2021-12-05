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

final class MainViewController: BaseViewController, WKUIDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var showServiceListsButton: UIButton!
    
    private let model = Model()
    private let viewModel = MainViewModel()
    private let webViewModel = WebViewModel()
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        launchScreenAnimation()
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        
        // 登録者判定
        if dataManager.isRegistrantCheck {
            wkWebView.load(Url.login.urlRequest())
        } else {
            wkWebView.load(Url.systemServiceList.urlRequest())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // 利用規約同意判定
        if !dataManager.isAgreementPersonDecision {
            Analytics.logEvent("calledFirstBootSetup", parameters: nil)
            
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func settingMenuButton(_ sender: Any) {
        let vc = R.storyboard.settings.settingsViewController()!
        present(vc, animated: false, completion: nil)
        vc.delegate = self
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        wkWebView.goBack()
    }
    
    @IBAction func tappedForwardButton(_ sender: Any) {
        wkWebView.goForward()
    }
        
    
    // MARK: - Public func
    public func refreshSyllabus(subjectName: String, teacherName: String) {
        webViewModel.subjectName = subjectName
        webViewModel.teacherName = teacherName
        wkWebView.load(Url.syllabus.urlRequest())
    }
    
    public func showModalView(scene: MainViewModel.NextModalView){
        switch scene {
        case .syllabus:
            let vc = R.storyboard.syllabus.syllabusViewController()!
            present(vc, animated: true, completion: nil)
            vc.delegate = self
            
        case .password:
            let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
            present(vc, animated: true, completion: nil)
            vc.delegate = self
            
        case .aboutThisApp:
            let vc = R.storyboard.aboutThisApp.aboutThisApp()!
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Private func
    // アニメーション
    private func launchScreenAnimation() {
        let launchScreenView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        launchScreenView.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1)
        launchScreenView.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        
        let imageView = UIImageView(image: R.image.mainIconWhite())
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
        imageView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        
        self.view.addSubview(launchScreenView)
        self.view.addSubview(imageView)
        
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
            imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (Bool) in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
            imageView.transform = CGAffineTransform(scaleX: 100, y: 100)
            imageView.alpha = 1
        }, completion: { (Bool) in
            imageView.removeFromSuperview()
            launchScreenView.removeFromSuperview()
        })
    }
        
}

// MARK: - WKUIDelegate
extension MainViewModel {
    
//    // MARK: - LifeCycle
//    override func viewDidLoad() {
//        wkWebView.uiDelegate = self
//    }
    
    /// 新しいウィンドウで開く「target="_blank"」
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // 変数 url にはリンク先のURLが入る
        webView.load(navigationAction.request)
        return nil
    }
}


// MARK: - WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {
    
    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // 現在の表示URL
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            AKLog(level: .ERROR, message: "リクエストエラー")
            return
        }
        Analytics.logEvent("webViewLoaded", parameters: [AnalyticsParameterItems: "\(url)"]) // Analytics: 調べる・タップ
        // URLをViewModelに保存
        webViewModel.registUrl(url)
        
        // 許可されたドメインか判定
        if !webViewModel.isDomeinCheck(url) {
            if let url = URL(string: dataManager.displayUrl) {
                AKLog(level: .DEBUG, message: "Safariで開く")
                UIApplication.shared.open(url)
                
            } else {
                AKLog(level: .ERROR, message: "URL変換エラー")
                toast(message: "失敗")
            }
            decisionHandler(.cancel)
            return
        }
        
        // タイムアウト判定
        if webViewModel.isJudgeUrl(.timeOut, isRegistrant: dataManager.isRegistrantCheck) {
            let response = webViewModel.url(.login)
            if let url = response as URLRequest? {
                webView.load(url)
            } else {
                toast(message: "失敗")
            }
        }
        
        decisionHandler(.allow)
        return
    }
    
    
    // MARK: - 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let isRegistrant = dataManager.isRegistrantCheck
        // 非登録者がログイン画面を開いた時
        if webViewModel.isJudgeUrl(.registrantAndLostConnectionDecision, isRegistrant: isRegistrant) {
            toast(message: "左上のボタンからパスワードを設定することで、自動でログインされる様になりますよ", interval: 3)
        }
        // MARK: - Question わける
        // 自動ログイン
        if webViewModel.isJudgeUrl(.login, isRegistrant: isRegistrant) {
            webView.evaluateJavaScript("document.getElementById('username').value= '\(DataManager.singleton.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(DataManager.singleton.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        }
        
        // 教務事務システム、アンケート催促スキップ
        if webViewModel.isJudgeUrl(.enqueteReminder, isRegistrant: isRegistrant) {
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        }
        
        // シラバス自動入力
        if webViewModel.isJudgeUrl(.syllabus, isRegistrant: isRegistrant) {
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(webViewModel.subjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(webViewModel.teacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
        }
        
        // outlookログイン
        if webViewModel.isJudgeUrl(.outlook, isRegistrant: isRegistrant) {
            webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(dataManager.cAccount)@tokushima-u.ac.jp'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
        }
        
        // キャリア支援室ログイン
        if webViewModel.isJudgeUrl(.tokudaiCareerCenter, isRegistrant: isRegistrant) {
            webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(dataManager.password)'", completionHandler:  nil)
        }
        
        
        ///
        /// Buttonデザインの変更
        ///

        DispatchQueue.main.async {
            // 教務事務システム、マナバ以外の画面かつ戻れる時
            let isBackEnabled = !self.webViewModel.isCourceManagementOrManaba() && webView.canGoBack
            self.goBackButton.isEnabled = isBackEnabled
            self.goBackButton.alpha = isBackEnabled ? 1.0 : 0.4
            self.goForwardButton.isEnabled = webView.canGoForward
            self.goForwardButton.alpha = webView.canGoForward ? 1.0 : 0.4
        }
        
    }
    
    
    /// alert対応
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        var messageText = message
        if dataManager.displayUrl == Url.courseRegistration.string() { // 履修登録の追加ボタンを押す際、ブラウザのポップアップブロックを解除せよとのalertが出る(必要ない)
            messageText = "OKを押してください"
        }
        let alertController = UIAlertController(title: "", message: messageText, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default) {
            action in completionHandler()
        }
        alertController.addAction(otherAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// confirm対応
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
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
    
    /// prompt対応
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        
        let okHandler: () -> Void = {
            if let textField = alertController.textFields?.first {
                completionHandler(textField.text)
            } else {
                completionHandler("")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action in completionHandler("")
        }
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in okHandler()
        }
        alertController.addTextField() { $0.text = defaultText }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - TabBar
extension MainViewController: UITabBarDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            Analytics.logEvent("mainViewCourceManagement", parameters: nil)
        } else {
            Analytics.logEvent("mainViewManaba", parameters: nil)
        }
        
        if let url = viewModel.tabBarDetection(tabBarRowValue: item.tag,
                                               isRegist: dataManager.isRegistrantCheck,
                                               courceType: dataManager.courceManagement,
                                               manabaType: dataManager.manaba) {
            wkWebView.load(url as URLRequest)
            
        } else {
            AKLog(level: .ERROR, message: "error")
            toast(message: "error")
            
        }
    }
}


