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
import PDFKit

final class MainViewController: BaseViewController{
    
    //MARK:- @IBOutlet
    @IBOutlet var viewTop: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tabBarUnder: UITabBar!
    @IBOutlet weak var tabBarLeft: UITabBarItem!
    @IBOutlet weak var backButton: UIButton!
    
    private var launchScreenView: UIView!
    private var launchScreenImage: UIImage!
    private var alertController: UIAlertController!
    
    private let model = Model()
    private let dataManager = DataManager()
    
    private var syllabusSubjectName = ""
    private var syllabusTeacherName = ""
    private var syllabusKeyword = ""
    
    private var url = ""
    
    private var onOffForRightButton = false
    private var onlyOnceForTimeSleep = false
    private var onlyOnceForSyllabusSearch = false
    private var onlyOnceForSyllabusPassdThrough = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView(scene: "launchScreen")
        
        tabBarUnder.delegate = self
        webView.navigationDelegate = self
        webView.isUserInteractionEnabled = true
        
        refresh()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // 利用規約同意画面
        firstBootDecision()
        // "cアカウント"、"パスワード"の設定催促
//        if (!registrantDecision()){
//            popupView(scene: "password")
//        }
    }
    

    //MARK:- @IBAction
    @IBAction func navigationLeftButton(_ sender: Any) {
        let vc = R.storyboard.settings.settingsViewController()!
        self.present(vc, animated: false, completion: nil)
        vc.delegateMain = self
//        switch webViewJudgeForTopURL() {
//        case true:
//            let vc = R.storyboard.settings.settingsViewController()!
//            self.present(vc, animated: false, completion: nil)
//            vc.delegateMain = self
//
//        case false:
//            webView.goBack()
//        }
    }
    
    @IBAction func navigationLeftButton2(_ sender: Any) {
        webView.goBack()
    }
    
    
    @IBAction func navigationCenterButton(_ sender: Any) {
        refresh()
    }

    @IBAction func navigationRightButton(_ sender: Any) {
        
        switch navigationRightButtonOnOff(){
        case true:
            let image = UIImage(systemName: "chevron.up")
            rightButton.setImage(image, for: .normal)
            animationView(scene: "rightButtonUp")

        case false:
            let image = UIImage(systemName: "chevron.down")
            rightButton.setImage(image, for: .normal)
            animationView(scene: "rightButtonDown")

        }
        onOffForRightButton = !onOffForRightButton
    }

    


    // MARK: - Public func
//    public func restoreView(){
//        animationView(scene: "restoreView")
//    }
    
    /// 文字列で指定されたURLをWeb Viewを開く
    public func openUrl(urlForRegistrant: String, urlForNotRegistrant: String?, alertTrigger:Bool) {
        var url = urlForRegistrant
        var trigger = alertTrigger
//        url = urlForRegistrant
        if (urlForRegistrant == model.libraryLoginURL){
            webViewDisplay(bool: true)
        }
        
        // 登録者判定
        if (registrantDecision() == false){
            if (url.contains(model.libraryLoginURL)){
                url = model.libraryHomeURL
                trigger = false
            }
            if let url1 = urlForNotRegistrant{
                url = url1
            }
            
            if (trigger) {
//                alert(title: "利用できません", message: "設定からcアカウントとパスワードを登録してください")
                toast(message: "パスワード設定をすることで利用できます", type: "bottom")
                webViewDisplay(bool: false)
                return
            }
        }
        let request = NSURLRequest(url: URL(string:url)!)
        
        webView.load(request as URLRequest)
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
    
    public func refreshSyllabus(subjectName: String, teacherName: String, keyword:String){
        syllabusSubjectName = subjectName
        syllabusTeacherName = teacherName
        syllabusKeyword = keyword

        onlyOnceForTimeSleep = true
        onlyOnceForSyllabusSearch = false
        openUrl(urlForRegistrant: model.syllabusURL, urlForNotRegistrant: nil, alertTrigger: false)
        
        webViewDisplay(bool: true)
    }

    public func refresh(){
//        leftButton.isEnabled = true
        webViewDisplay(bool: true)
        tabBarUnder.selectedItem = tabBarLeft
        openUrl(urlForRegistrant: model.loginURL, urlForNotRegistrant: model.systemServiceListURL, alertTrigger: false)
    }
    
    // MARK: - Private func
    
    private func webViewIsHidden(){
        let webViewIsHiddonFalseURLs = [model.syllabusSearchMainURL,
                                        model.courceManagementHomeURL,
                                        model.systemServiceListURL,
                                        model.manabaURL,
                                        model.eLearningListURL,
                                        model.libraryHomeURL,
                                        model.libraryLoginURL]
        for i in webViewIsHiddonFalseURLs{ // 上記のURLの場合、画面を表示
            if (model.displayURL.contains(i)){
                webViewDisplay(bool: false)
                return
            }
        }
        
        if (model.displayURL == model.syllabusURL){
            if (onlyOnceForTimeSleep && onlyOnceForSyllabusPassdThrough){
                webViewDisplay(bool: false)
                onlyOnceForTimeSleep = false
                onlyOnceForSyllabusPassdThrough = false
                return
            }else{
                onlyOnceForSyllabusPassdThrough = true
            }
        }
        
        // ログイン
        if (model.displayURL.contains(model.lostConnectionURL)){
            if (model.displayURL.suffix(2) != "s1"){ // ログインできなかった時
                webViewDisplay(bool: false)
                return
            }
        }
    }
    
    private func webViewDisplay(bool: Bool){
        switch bool {
        case true:
            leftButton.isEnabled = false
            webView.isHidden = true
            activityIndicator.startAnimating()
            
        case false:
            leftButton.isEnabled = true
            webView.isHidden = false
            activityIndicator.stopAnimating()
            
        }
    }
    
    /// アカウント登録者ならtrue
    private func registrantDecision() -> Bool{
        if (dataManager.cAccount != "" &&
                dataManager.passWord != ""){
            return true
        }else{
            return false
        }
    }
    
    
    /// tabBar左ボタンの画像を入れ替える際の判定
    private func webViewJudgeForTopURL() -> Bool {
        for url in model.topMenuURLs{
            if (model.displayURL.contains(url)){
                return true
            }
        }
        return false
    }
    
    // webViewの位置によってボタンの機能を判定
    private func navigationRightButtonOnOff() -> Bool{
        let webViewPositionY = webView.frame.origin.y
        if (webViewPositionY == 0.0){
            return true
        }else{
            return false
        }
    }
    
    /// アニメーション
    private func animationView(scene:String){
        switch scene {
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
            
        case "launchScreen":
            launchScreenView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
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
                    self.launchScreenView.removeFromSuperview()
            })
        default:
            return
        }
    }
    
    // 初回起動時判定
    private func firstBootDecision() {
        let value = UserDefaults.standard.bool(forKey: "FirstBootDecision")
        if value == true{
            return
        }else{
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
        }
    }
}


//MARK:- WebView
extension MainViewController: WKNavigationDelegate{
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        // 現在表示してるURL
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        model.displayURL = url.absoluteString
        print("displayURL : " + model.displayURL)
        
        // 許可するドメインを指定
        guard let host = navigationAction.request.url?.host else {
            return
        }
        // [tokushima-u.ac.jp] 以外はSafariで開く
        if (host.contains(model.allowDomain) == false){
            UIApplication.shared.open(URL(string: String(describing: model.displayURL))!)
            decisionHandler(.allow)
            return
        }
        
        
        // <a href="..." target="_blank"> 判定
        if (navigationAction.navigationType == .linkActivated){
            if navigationAction.targetFrame == nil
                || !navigationAction.targetFrame!.isMainFrame { // 新しく開かれるタブを新しいURLとして読み込む
                openUrl(urlForRegistrant: url.absoluteString, urlForNotRegistrant: nil, alertTrigger: false)
                decisionHandler(.cancel)
                return
            }
        }
        
        // Manabaの授業Youtubeリンクのタップ判定
        if (model.displayURL.contains(model.popupToYoutubeURL)){
            // Youtubeリンクを取得
            webView.evaluateJavaScript("document.linkform_iframe_balloon.url.value", completionHandler: { (html, error) -> Void in
                if let htmlYoutube = html{ // type(of: htmlYoutube) >>> __NSCFString
                    UIApplication.shared.open(URL(string: String(describing: htmlYoutube))!)
                    return
                }else{
                    webView.goBack()
//                    self.alert(title: "エラー", message: "表示できませんでした")
//                    alertOk(title: "e", message: <#T##String#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
                    return
                }
            })
        }
        
        // タイムアウト判定
        if (model.displayURL == model.timeOutURL){
            webViewDisplay(bool: true)
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
        
        if (model.displayURL == "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx"){
            openUrl(urlForRegistrant: model.courceManagementHomeURL, urlForNotRegistrant: nil, alertTrigger: false)
        }

        // Login画面
        if (model.displayURL.contains(model.lostConnectionURL) && model.displayURL.suffix(2)=="s1"){ // 2回目は"=e1s2"
            webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        }

        // 教務事務システム、アンケート催促スキップ
        if (model.displayURL == model.enqueteReminderURL){
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        }

        // シラバス
        if (model.displayURL.contains(model.syllabusURL) && !onlyOnceForSyllabusSearch){
            onlyOnceForSyllabusSearch = true
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(syllabusSubjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(syllabusTeacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(syllabusKeyword)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
        }
        
        // ハンバーガーメニューのボタン画像変更
//        switch webViewJudgeForTopURL() {
//        case true:
//            let image = UIImage(systemName: "line.horizontal.3")
//            leftButton.setImage(image, for: .normal)
//
//        case false:
//            let image = UIImage(systemName: "arrowshape.turn.up.left")
//            leftButton.setImage(image, for: .normal)
//
//        }
        
        // WebView表示、非表示　判定
        webViewIsHidden()
    }
}


extension MainViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1: // 左
            webViewDisplay(bool: true)
            openUrl(urlForRegistrant: model.courceManagementHomeURL, urlForNotRegistrant: model.systemServiceListURL, alertTrigger: false)
        case 2: // 右
            webViewDisplay(bool: true)
            openUrl(urlForRegistrant: model.manabaURL, urlForNotRegistrant: model.eLearningListURL, alertTrigger: false)
        default:
            return
        }
    }
}
