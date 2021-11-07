//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit

final class MainViewController: BaseViewController, WKUIDelegate{
    
    // MARK: - IBOutlet
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var reversePCtoSP: UIButton!
    @IBOutlet weak var tabBarLeft: UITabBarItem!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    private let model = Model()
    private let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    private let webViewModel = WebViewModel.singleton


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        refresh()
        initViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)

        firstBootSetup()       // 利用規約同意判定
        registrantDecision()   // 登録者判定
    }


    // MARK: - IBAction
    @IBAction func settingMenuButton(_ sender: Any) {
        
        let vc = R.storyboard.settings.settingsViewController()!
        self.present(vc, animated: false, completion: nil)
        vc.delegate = self
//        vc.mainViewModel = self.viewModel
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        webView.goBack()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        refresh()
        navigationRightButtonOnOff(operation: "UP")
    }
    
    @IBAction func webViewChangePCorMB(_ sender: Any) {
        
        let response = viewModel.isDisplayUrlForPC()
        if let image = response.0 {
            reversePCtoSP.setImage(image, for: .normal)
            self.webView.load(response.1)
        }
    }
    
    @IBAction func webViewMoveToUpDownButton(_ sender: Any) {
        
        navigationRightButtonOnOff(operation: "REVERSE")
    }
    

    // MARK: - Public func
    public func refresh() { // 教務事務システムに再度ログイン
        
        tabBar.selectedItem = tabBarLeft
        self.activityIndicatorView.isHidden = true
        
        if let url = webViewModel.url(.login) {
            webView.load(url as URLRequest)
            
        } else {
            toast(message: "登録者のみ")
        }
    }
    
    
    public func refreshSyllabus(subjectName: String, teacherName: String, keyword:String){
        
        let response = webViewModel.url(.syllabus)
        if let url = response as URLRequest? {
            webView.load(url)
        } else {
            toast(message: "登録者のみ")
        }
        
    }


    public func popupView(scene: MainViewModel.NextView){
        
        switch scene {
            
        case .syllabus:
            let vc = R.storyboard.syllabus.syllabusViewController()!
            self.present(vc, animated: true, completion: nil)
            vc.delegate = self
            
            
        case .password:
            let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
            self.present(vc, animated: true, completion: nil)
            vc.delegate = self
            
            
        case .aboutThisApp:
            let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
            self.present(vc, animated: true, completion: nil)
            

        }
        
    }
        
    
    // webViewを上げ下げする
    public func navigationRightButtonOnOff(operation: String){

        viewModel.viewPosisionType(operation: operation, posisionY: webView.frame.origin.y)
        
        let image = UIImage(systemName: viewModel.imageSystemName)
        rightButton.setImage(image, for: .normal)
        animationView(scene: viewModel.animationView)
        
    }
    
    
    // MARK: - Private func
    
    private func setup() {
        
        animationView(scene: "launchScreen")
        tabBar.delegate = self
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    
    // 初回起動時
    private func firstBootSetup() {
        
        if !agreementPersonDecision() {
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
        }
    }
    
    private func registrantDecision() {
        
        if (!webViewModel.registrantDecision()) {
            // "cアカウント"、"パスワード"の設定催促
            let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
            self.present(vc, animated: true, completion: nil)
            vc.delegate = self
        }
    }
    
    
    // 利用規約同意者か判定
    private func agreementPersonDecision() -> Bool{
        return UserDefaults.standard.bool(forKey: model.agreementVersion)
    }
    
    
    // 表示:true  非表示：false
    private func webViewDisplay(_ bool: Bool){

        switch bool {
        case true:
            leftButton.isEnabled = true
            self.activityIndicatorView.isHidden = true
            activityIndicator.stopAnimating()

        case false:
            leftButton.isEnabled = false
            self.activityIndicatorView.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
    // アニメーション
    private func animationView(scene:String){
        switch scene {
        case "launchScreen":
            
            let launchScreenView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            launchScreenView.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1)
            launchScreenView.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            
            let imageView = UIImageView(image:UIImage(named:"tokumemoIcon1")!)
            imageView.frame = CGRect(x:0, y:0, width:50, height:50);
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
                    imageView.transform = CGAffineTransform(scaleX: 50, y: 50)
                    imageView.alpha = 0.1
                }, completion: { (Bool) in
                    imageView.removeFromSuperview()
                    launchScreenView.removeFromSuperview()
            })
            
        case "rightButtonUp":
            UIView.animate(
                withDuration: 0.5,
                delay: 0.08,
                options: .curveEaseOut,
                animations: {
                    self.webView.layer.position.y += 60
            },
                completion: { bool in
            })
            
        case "rightButtonDown":
            UIView.animate(
                withDuration: 0.5,
                delay: 0.08,
                options: .curveEaseOut,
                animations: {
                    self.webView.layer.position.y -= 60
                },
                completion: { bool in
                })

        default:
            return
        }
    }
    
    
    /// ViewModel初期化
    private func initViewModel() {
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.state = { [weak self] (state) in
            guard let self = self else {
                fatalError()
            }
            DispatchQueue.main.async {
                switch state {
                case .busy: // 通信中
                    let vc = R.storyboard.syllabus.syllabusViewController()!
                    self.present(vc, animated: true, completion: nil)
                    break
                    
                case .ready: // 通信完了
                    
                    break
                    
                    
                case .error:
                    break
                    
                }//end switch
            }
        }
    }
    
}


//MARK:- WebView
extension MainViewController: WKNavigationDelegate{
    
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
        
        // URLをViewModelに保存
        webViewModel.registUrl(url)
        
        // 許可されたドメインか判定
        if !webViewModel.isDomeinInspection(url) {
            if let url = URL(string: webViewModel.displayUrl) {
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
        if webViewModel.isJudgeUrl(.timeOut) {
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
        
        // 戻るボタンの有効判定
        self.backButton.isEnabled = webView.canGoBack
        self.backButton.alpha = webView.canGoBack ? 1.0 : 0.4
        
        // 非登録者がログイン画面を開いた時
        if webViewModel.isJudgeUrl(.registrantAndLostConnectionDecision) {
            toast(message: "左上のボタンからパスワードを設定することで、自動でログインされる様になりますよ", type: "bottom", interval: 3)
        }
        
        // 自動ログイン
        if webViewModel.isJudgeUrl(.login) {
            webView.evaluateJavaScript("document.getElementById('username').value= '\(DataManager.singleton.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(DataManager.singleton.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        }
        
        // 教務事務システム、アンケート催促スキップ
        if webViewModel.isJudgeUrl(.enqueteReminder) {
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        }

        // シラバス自動入力
        if webViewModel.isJudgeUrl(.syllabus) {
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(webViewModel.syllabusSubjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(webViewModel.syllabusTeacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(webViewModel.syllabusKeyword)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
        }
        
        // outlookログイン
        if webViewModel.isJudgeUrl(.outlook) {
            webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(webViewModel.userCAccountMailAdress)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(DataManager.singleton.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
        }
        
        // キャリア支援室ログイン
        if webViewModel.isJudgeUrl(.tokudaiCareerCenter) {
            webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(DataManager.singleton.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(DataManager.singleton.password)'", completionHandler:  nil)
        }
        
        // 教務事務システム or マナバ のPC版かMB版かの判定
//        if let url = webViewModel.CMAndManabaPCtoMB() {
//            webView.load(url)
//        }
        
        // 現在の画面がモバイル版かPC版かViewModelに登録
        webViewModel.judgeMobileOrPC()
        
        // モバイル版かPC版のアイコンを設定
        let image = UIImage(named: webViewModel.reversePCtoSPIconName)
        reversePCtoSP.setImage(image, for: .normal)
        reversePCtoSP.isEnabled = webViewModel.reversePCtoSPIsEnabled
        
    }
    
    
    // alert対応
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        var messageText = message
        if webViewModel.displayUrl == UrlModel.courseRegistration.string() { // 履修登録の追加ボタンを押す際、ブラウザのポップアップブロックを解除せよとのalertが出る(必要ない)
            messageText = "OKを押してください"
        }
        let alertController = UIAlertController(title: "", message: messageText, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default) {
            action in completionHandler()
        }
        alertController.addAction(otherAction)
        present(alertController, animated: true, completion: nil)
    }

    // confirm対応
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

    // prompt対応
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
    
    /// 新しいウィンドウで開く「target="_blank"」
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // 変数 url にはリンク先のURLが入る
        if let url = navigationAction.request.url {
            webView.load(URLRequest(url: url))
            return webView
        }
        AKLog(level: .ERROR, message: "リクエストエラー")
        return nil
        
    }
}


//MARK:- TabBar
extension MainViewController: UITabBarDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let url = viewModel.tabBarDetection(num: item.tag) {
            webView.load(url as URLRequest)
            
        } else {
            AKLog(level: .ERROR, message: "error")
            toast(message: "error")
            
        }
//        navigationRightButtonOnOff(operation: "DOWN")
    }
}


