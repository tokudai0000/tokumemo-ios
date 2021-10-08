//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//


/*
 JavaScript 要素取得方法
 https://qiita.com/amamamaou/items/25e8b4e1b41c8d3211f4
 */


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
    @IBOutlet weak var tabBarLeft: UITabBarItem!
    @IBOutlet weak var activityIndicatorView: UIView!
    
//    private var activityIndicatorView: UIView!
    
    private let model = Model()
    private let dataManager = DataManager()
    
    // SyllabusViewの内容を渡され保存し、Webに入力する
    private var syllabusSubjectName = ""
    private var syllabusTeacherName = ""
    private var syllabusKeyword = ""
    
    // 現在表示しているURL
    private var displayURL = ""
    
    // Dos攻撃を防ぐ為、1度ログイン処理したら結果の有無に関わらず終了させる
    private var onlyOnceForLogin = false
    
    private var syllabusSearchOnce = false
    private var syllabusPassdThroughOnce = false


    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView(scene: "launchScreen")
        tabBar.delegate = self
        webView.navigationDelegate = self
        webView.uiDelegate = self
//        activityIndicatorView = UIView.init(frame: CGRect.init(x: 0, y: 60, width: self.view.frame.width, height: self.viewTop.frame.size.height-280))
//        print(self.viewTop.frame.size.height)
//        let bgColor = UIColor.black
//        activityIndicatorView.alpha = 0.5
//        activityIndicatorView.backgroundColor = bgColor
//        self.viewTop.addSubview(activityIndicatorView)
        refresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // 利用規約同意画面
        firstBootDecision()
        
        // "cアカウント"、"パスワード"の設定催促
        if (!registrantDecision()){
            popupView(scene: "password")
        }
    }
    

    //MARK:- IBAction
    @IBAction func navigationLeftButton(_ sender: Any) {
        let vc = R.storyboard.settings.settingsViewController()!
        self.present(vc, animated: false, completion: nil)
        vc.delegateMain = self
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


    // MARK: - Public func
    
    // 文字列で指定されたURLを開く
    public func openUrl(urlForRegistrant: String, urlForNotRegistrant: String?, alertTrigger:Bool) {
        
        webViewDisplay(bool: true)
        onlyOnceForLogin = false
        // 登録者判定
        if registrantDecision(){
            let request = NSURLRequest(url: URL(string:urlForRegistrant)!)
            webView.load(request as URLRequest)
            
        }else{
            if alertTrigger {
                toast(message: "パスワード設定をすることで利用できます", type: "bottom")
                webViewDisplay(bool: false)
                return
            }
            
            guard let url = urlForNotRegistrant else {
//                url = urlForRegistrant
                toast(message: "エラーが起こりました", type: "bottom")
                return
            }
//            let url = urlForRegistrant
            
            let request = NSURLRequest(url: URL(string:url)!)
            webView.load(request as URLRequest)
        }
    }
    
    public func refresh(){
        onlyOnceForLogin = false
        tabBar.selectedItem = tabBarLeft
        
        openUrl(urlForRegistrant: model.loginURL, urlForNotRegistrant: model.systemServiceListURL, alertTrigger: false)
    }
    
    public func refreshSyllabus(subjectName: String, teacherName: String, keyword:String){
        syllabusSubjectName = subjectName
        syllabusTeacherName = teacherName
        syllabusKeyword = keyword
        syllabusSearchOnce = true
        
        openUrl(urlForRegistrant: model.syllabusURL, urlForNotRegistrant: model.syllabusURL, alertTrigger: false)
    }

    public func popupView(scene: String){
        switch scene {
        case "firstView":
            let vc = R.storyboard.syllabus.syllabusViewController()!
            self.present(vc, animated: true, completion: nil)
        case "syllabus":
            let vc = R.storyboard.syllabus.syllabusViewController()!
            self.present(vc, animated: true, completion: nil)
            vc.delegateMain = self
        case "password":
            let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
            self.present(vc, animated: true, completion: nil)
            vc.delegateMain = self
        case "aboutThisApp":
            let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
            self.present(vc, animated: true, completion: nil)
        case "contactToDeveloper":
            let vc = R.storyboard.contactToDeveloper.contactToDeveloperViewController()!
            self.present(vc, animated: true, completion: nil)
        default:
            return
        }
    }
    
    // webViewを上げ下げする
    public func navigationRightButtonOnOff(operation: String){
        
        let webViewPositionY = webView.frame.origin.y
        var ope = ""
        switch operation {
        case "UP":
            if (webViewPositionY != 0.0){
                ope = "UP"
            }
            
        case "DOWN":
            if (webViewPositionY == 0.0){
                ope = "DOWN"
            }
            
        case "REVERSE":
            if (webViewPositionY == 0.0){
                ope = "DOWN"
            }else{
                ope = "UP"
            }
        default:
            return
        }
        
        switch ope {
        case "UP":
            let image = UIImage(systemName: "chevron.down")
            rightButton.setImage(image, for: .normal)
            animationView(scene: "rightButtonDown")
            return
        case "DOWN":
            let image = UIImage(systemName: "chevron.up")
            rightButton.setImage(image, for: .normal)
            animationView(scene: "rightButtonUp")
        default:
            return
        }
    }
    
    
    
    // MARK: - Private func
    
    // 初回起動時判定
    private func firstBootDecision() {
        // 利用規約同意者か判定
        let value = UserDefaults.standard.bool(forKey: "FirstBootDecision")
        if value{
            return
        }else{
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            
        }
    }
    
    // WebViewの表示、非表示を判定
    private func webViewHiddenJudge(){
        // ＊＊改修必須（バグの元）＊＊
        let webViewIsHiddonFalseURLs = [model.syllabusSearchMainURL,
                                        model.courceManagementHomeURL,
                                        model.systemServiceListURL,
                                        model.manabaURL,
                                        model.manabaPCURL,
                                        model.eLearningListURL,
                                        model.libraryHomeURL,
                                        model.libraryLoginURL,
                                        model.timeTableURL,
                                        model.currentTermPerformanceURL,
                                        model.termPerformanceURL,
                                        model.presenceAbsenceRecordURL,
                                        model.libraryBookLendingExtensionURL,
                                        model.libraryBookPurchaseRequestURL,
                                        model.classQuestionnaire,
                                        model.outlookHomeURL]
        // 上記のURLの場合、画面を表示
        for url in webViewIsHiddonFalseURLs{
            if (displayURL.contains(url)){
                webViewDisplay(bool: false)
                return
            }
        }
        
        // ログインできなかった時
        if displayURL.contains(model.lostConnectionURL) &&
            displayURL.suffix(4) != "e1s1"{
            webViewDisplay(bool: false)
            return
        }
        
        // シラバス
        if displayURL == model.syllabusURL{
            // 2回目に通った時
            if syllabusPassdThroughOnce{
                webViewDisplay(bool: false)
                syllabusPassdThroughOnce = false
                return
            }else{
                syllabusPassdThroughOnce = true
            }
        }
    }
    
    // 表示:false  非表示：true
    private func webViewDisplay(bool: Bool){
//        myView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 500))
//        myView.alpha = 0.5
//        myView.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
//        self.view.addSubview(myView)
//        self.view.bringSubviewToFront(myView)
//        let activityIndicatorView = UIView.init(frame: CGRect.init(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 89))
//        let bgColor = UIColor.black
//        activityIndicatorView.alpha = 0.5
//        activityIndicatorView.backgroundColor = bgColor
//        self.view.addSubview(activityIndicatorView)
        
        switch bool {
        case true:
            leftButton.isEnabled = false
//            webView.isHidden = true
            self.activityIndicatorView.isHidden = false
            activityIndicator.startAnimating()

        case false:
            leftButton.isEnabled = true
//            webView.isHidden = false
            self.activityIndicatorView.isHidden = true
            activityIndicator.stopAnimating()
            
        }
    }
    
    // アカウント登録者判定　登録者：true　　非登録者：false
    private func registrantDecision() -> Bool{
        if (dataManager.cAccount == "" &&
                dataManager.passWord == ""){
            return false
            
        }else{
            return true
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
}


//MARK:- WebView
extension MainViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 変数 url にはリンク先のURLが入る
        if let url = navigationAction.request.url {
            openUrl(urlForRegistrant: url.absoluteString, urlForNotRegistrant: url.absoluteString, alertTrigger: false)
            webViewDisplay(bool: false)
        }
         
        return nil
    }
    // 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        // 現在表示してるURL
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        displayURL = url.absoluteString
        print("displayURL : " + displayURL)
        
        
        // 許可するドメインを指定
        guard let host = url.host else{
            return
        }
        // [model.allowDomains] 以外はSafariで開く
        var trigger = false
        for allow in model.allowDomains {
            if host.contains(allow){
                trigger = true
            }
        }
        if trigger == false{
            print(displayURL)
            print("a")
            UIApplication.shared.open(URL(string: String(describing: displayURL))!)
            decisionHandler(.cancel)
            return
        }
        
        // <a href="..." target="_blank"> (新しいタブで開く)判定
//        if (navigationAction.navigationType == .linkActivated){
//            if navigationAction.targetFrame == nil
//                || !navigationAction.targetFrame!.isMainFrame { // 新しく開かれるタブを新しいURLとして読み込む
//                openUrl(urlForRegistrant: url.absoluteString, urlForNotRegistrant: url.absoluteString, alertTrigger: false)
//                webViewDisplay(bool: false)
//                decisionHandler(.cancel)
//                return
//            }
//        }
        
        // Manabaの授業Youtubeリンクのタップ判定
        if (displayURL.contains(model.popupToYoutubeURL)){
            // Youtubeリンクを取得
            webView.evaluateJavaScript("document.linkform_iframe_balloon.url.value", completionHandler: { (html, error) -> Void in
                if let htmlYoutube = html{ // type(of: htmlYoutube) >>> __NSCFString
                    UIApplication.shared.open(URL(string: String(describing: htmlYoutube))!)
                    return
                }else{
                    webView.goBack()
                    self.toast(message: "エラー")
                    return
                }
            })
        }
        
        // タイムアウト判定
        if (displayURL == model.timeOutURL){
            openUrl(urlForRegistrant: model.loginURL, urlForNotRegistrant: model.systemServiceListURL, alertTrigger: false)
        }
        
        decisionHandler(.allow)
        return
    }


    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.backButton.isEnabled = webView.canGoBack
            self.backButton.alpha = webView.canGoBack ? 1.0 : 0.4
        }
        // KeyChain
        let cAcaunt = dataManager.cAccount
        let passWord = dataManager.passWord
        if !registrantDecision(){
            if displayURL.contains(model.lostConnectionURL){
                toast(message: "左上のボタンからパスワードを設定することで、自動でログインされる様になりますよ", type: "bottom", interval: 5)
            }
        }
        
        // PCサイトへ飛ばされた場合
        if (displayURL == model.courceManagementHomePCURL){
            openUrl(urlForRegistrant: model.courceManagementHomeURL, urlForNotRegistrant: model.systemServiceListURL, alertTrigger: false)
        }

        // Login画面
        if !onlyOnceForLogin{ // ddosにならない様に対策
            if (displayURL.contains(model.lostConnectionURL) && displayURL.suffix(2)=="s1"){ // 2回目は"=e1s2"
                webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
                onlyOnceForLogin = true
            }
        }

        // 教務事務システム、アンケート催促スキップ
        if (displayURL == model.enqueteReminderURL){
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        }

        // シラバス
        if (displayURL.contains(model.syllabusURL) && syllabusSearchOnce){
            syllabusSearchOnce = false
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(syllabusSubjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(syllabusTeacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(syllabusKeyword)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
        }
        
        // outlookログイン
        if displayURL.contains(model.outlookLoginURL){
            let mailAdress = cAcaunt + "@tokushima-u.ac.jp"
            webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(mailAdress)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(passWord)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
            webViewDisplay(bool: false)
        }
        
        // キャリア支援室ログイン
        if displayURL == model.tokudaiCareerCenterURL{
            webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(cAcaunt)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(passWord)'", completionHandler:  nil)
            webViewDisplay(bool: false)
        }
        
        // WebView表示、非表示　判定
        webViewHiddenJudge()
    }
}


//MARK:- TabBar
extension MainViewController: UITabBarDelegate{
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1: // 左
            openUrl(urlForRegistrant: model.courceManagementHomeURL, urlForNotRegistrant: model.systemServiceListURL, alertTrigger: false)
            navigationRightButtonOnOff(operation: "UP")
        case 2: // 右
            openUrl(urlForRegistrant: model.manabaURL, urlForNotRegistrant: model.eLearningListURL, alertTrigger: false)
            navigationRightButtonOnOff(operation: "UP")
        default:
            return
        }
    }
}


