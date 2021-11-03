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
    
    //MARK:- IBOutlet
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
    private let urlModel = UrlModel()
    private let viewModel = MainViewModel()
    private let dataManager = DataManager()


    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupWKWebView()
        
        refresh()
        initViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // 利用規約同意判定
        firstBootSetup()
        
        // 登録者判定
        if (!viewModel.registrantDecision()) {
            // "cアカウント"、"パスワード"の設定催促
            let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
            self.present(vc, animated: true, completion: nil)
            vc.delegateMain = self
        }
        
    }


    //MARK:- IBAction
    @IBAction func navigationLeftButton(_ sender: Any) {
        let vc = R.storyboard.settings.settingsViewController()!
        self.present(vc, animated: false, completion: nil)
        vc.delegateMain = self
        vc.mainViewModel = self.viewModel
        vc.urlModel = self.urlModel
    }
    
    @IBAction func navigationLeftButton2(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func navigationCenterButton(_ sender: Any) {
        refresh()
        navigationRightButtonOnOff(operation: "UP")
    }

    @IBAction func navigationRightButton(_ sender: Any) {
        navigationRightButtonOnOff(operation: "REVERSE")
    }
    
    @IBAction func revercePCtoSP(_ sender: Any) {
        let image = UIImage(named: viewModel.isDisplayUrlForPC())
        reversePCtoSP.setImage(image, for: .normal)

    }
    

    // MARK: - Public func
    
    public func refresh(){
//        webViewDisplay(bool: false)
        self.activityIndicatorView.isHidden = true
        
        tabBar.selectedItem = tabBarLeft
        
        let response = urlModel.url(.login)
        if let url = response.1 as URLRequest? {
            webView.load(url)
        } else {
            toast(message: "登録者のみ")
        }
        
    }
    
    
    public func refreshSyllabus(subjectName: String, teacherName: String, keyword:String){
        
        let response = urlModel.url(.syllabus)
        if let url = response.1 as URLRequest? {
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
            vc.delegateMain = self
            
            
        case .password:
            let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
            self.present(vc, animated: true, completion: nil)
            vc.delegateMain = self
            
            
        case .aboutThisApp:
            let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
            self.present(vc, animated: true, completion: nil)
            
            
        case .contactToDeveloper:
            let vc = R.storyboard.contactToDeveloper.contactToDeveloperViewController()!
            self.present(vc, animated: true, completion: nil)
        }
        
    }
        
    
    // webViewを上げ下げする
    public func navigationRightButtonOnOff(operation: String){
        
        viewModel.viewPosisionType(posisionY: webView.frame.origin.y)
        
        let image = UIImage(systemName: viewModel.imageSystemName)
        rightButton.setImage(image, for: .normal)
        animationView(scene: viewModel.animationView)
        
    }
    
    
    // MARK: - Private func
    private func setup() {
        
        animationView(scene: "launchScreen")
        tabBar.delegate = self
    }
    
    
    private func setupWKWebView() {
        
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
    
    // 利用規約同意者か判定
    private func agreementPersonDecision() -> Bool{
        return UserDefaults.standard.bool(forKey: model.agreementVersion)
    }
    
    
    // WebViewの表示、非表示を判定
//    private func webViewHiddenJudge(){
//        webViewDisplay(bool: false)
//        return
        // 上記のURLの場合、画面を表示
//        for (_, value) in model.urls{
//            if displayURL.contains(value.url) && value.topView {
//                webViewDisplay(bool: false)
//                return
//            }
//        }
        
        // ログインできなかった時
//        if displayURL.contains(model.urls["lostConnection"]!.url) &&
//            displayURL.suffix(4) != "e1s1"{
//            webViewDisplay(bool: false)
//            return
//        }
        
        // シラバス
//        if displayURL == model.urls["syllabus"]!.url{
//            // 2回目に通った時
//            if viewModel.syllabusPassdThroughOnce{
//                webViewDisplay(bool: false)
//                viewModel.syllabusPassdThroughOnce = false
//                return
//            }else{
//                viewModel.syllabusPassdThroughOnce = true
//            }
//        }
        
//    }
    
    
    // 表示:false  非表示：true
    private func webViewDisplay(bool: Bool){

//        switch bool {
//        case true:
//            leftButton.isEnabled = false
//            self.activityIndicatorView.isHidden = false
//            activityIndicator.startAnimating()
//
//        case false:
//            leftButton.isEnabled = true
//            self.activityIndicatorView.isHidden = true
//            activityIndicator.stopAnimating()
//        }

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
            imageView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2 + 10)
            
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
//                    self.activityIndicator.startAnimating()
                    let vc = R.storyboard.syllabus.syllabusViewController()!
                    self.present(vc, animated: true, completion: nil)
                    break
                    
                case .ready: // 通信完了
//                    self.activityIndicator.stopAnimating()
                    // View更新
//                    self.tableView.reloadData()
//                    self.refreshControl.endRefreshing()
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
        viewModel.registUrl(url)
        
        // 許可されたドメインか判定
        if !viewModel.isDomeinInspection(url) {
            if let url = URL(string: viewModel.displayUrl) {
                UIApplication.shared.open(url)
            } else {
                AKLog(level: .ERROR, message: "URL変換エラー")
                toast(message: "失敗")
            }
            decisionHandler(.cancel)
            return
        }
        
        // タイムアウト判定
        if viewModel.isJudgeTimeOut() {
            let response = urlModel.url(.login)
            if let url = response.1 as URLRequest? {
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
        if viewModel.isRegistrantAndLostConnectionDecision() {
            toast(message: "左上のボタンからパスワードを設定することで、自動でログインされる様になりますよ", type: "bottom", interval: 3)
        }
        
        // 自動ログイン
        if viewModel.judgeLogin() {
            webView.evaluateJavaScript("document.getElementById('username').value= '\(viewModel.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(viewModel.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        }
        
        // 教務事務システム、アンケート催促スキップ
        if viewModel.judgeEnqueteReminder() {
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        }

        // シラバス自動入力
        if viewModel.judgeSyllabus() {
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(viewModel.syllabusSubjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(viewModel.syllabusTeacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(viewModel.syllabusKeyword)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
        }
        
        // outlookログイン
        if viewModel.judgeOutlook() {
            webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(viewModel.mailAdress)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(viewModel.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
        }
        
        // キャリア支援室ログイン
        if viewModel.judgeTokudaiCareerCenter() {
            webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(viewModel.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(viewModel.password)'", completionHandler:  nil)
        }
        
        // 教務事務システム or マナバ のPC版かMB版かの判定
        if let url = viewModel.CMAndManabaPCtoMB() {
            webView.load(url)
        }
        
        // 現在の画面がモバイル版かPC版か検知
        viewModel.judgeMobileOrPC()
        
        // モバイル版かPC版のアイコンを設定
        let image = UIImage(named: viewModel.reversePCtoSPIconName)
        reversePCtoSP.setImage(image, for: .normal)
        reversePCtoSP.isEnabled = viewModel.reversePCtoSPIsEnabled
        
    }
    
    
    // alert対応
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        var messageText = message
        if viewModel.displayUrl == urlModel.courseRegistration{ // 履修登録の追加ボタンを押す際、ブラウザのポップアップブロックを解除せよとのalertが出る(必要ない)
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

        // variable to keep a reference to UIAlertController
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
//            webViewDisplay(bool: false)
            return webView
        }
        AKLog(level: .ERROR, message: "リクエストエラー")
        return nil
        
    }
}


//MARK:- TabBar
extension MainViewController: UITabBarDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let url = viewModel.tabBarDetection(num: item.tag) as URLRequest? {
            webView.load(url)
        } else {
            AKLog(level: .ERROR, message: "error")
            toast(message: "error")
        }
        navigationRightButtonOnOff(operation: "UP")
    }
    
}


