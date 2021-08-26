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

final class MainViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate, UITabBarDelegate {
    //MARK:- @IBOutlet
    @IBOutlet var viewTop: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tabBarUnder: UITabBar!
    @IBOutlet weak var tabBarLeft: UITabBarItem!
    
    private var launchScreenView: UIView!
    private var launchScreenImage: UIImage!
    private var alertController: UIAlertController!
    var ActivityIndicator: UIActivityIndicatorView!
    
    private let module = Module()
    private var dataManager = DataManager()
    
    private var syllabusSubjectName = ""
    private var syllabusTeacherName = ""
    private var syllabusKeyword = ""
    
    private var url = ""
    
    private var onOffForRightButton = false
    private var onlyOnceForTimeSleep = false
    private var onlyOnceForSyllabusSearch = false
    private var onlyOnceForSyllabusPassdThrough = false

    //MARK:- LifeCycle
    override func loadView() {
        super.loadView()
        viewAnimated(scene: "launchScreen")
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
//        if (!registrantDecision()){
//            popupView(scene: "password")
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarUnder.delegate = self
        webView.navigationDelegate = self
        webView.isUserInteractionEnabled = true
        
        
        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center

        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true

        // 色を設定
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray

        //Viewに追加
        self.view.addSubview(ActivityIndicator)
        
        refresh()
    }


    //MARK:- @IBAction
    @IBAction func leftButton(_ sender: Any) {
        
        switch viewTopConfirmation() {
        case true:
            let vc = R.storyboard.settings.settingsViewController()!
            self.present(vc, animated: false, completion: nil)
            vc.delegateMain = self
            
        case false:
            webView.goBack()
            
        }
    }
    
    @IBAction func centerButton(_ sender: Any) {
        refresh()
    }
    

    @IBAction func rightButton(_ sender: Any) {
        switch onOffForRightButton {
        case true:
            let image = UIImage(systemName: "chevron.down")
            rightButton.setImage(image, for: .normal)
            viewAnimated(scene: "rightButtonDown")

        case false:
            let image = UIImage(systemName: "chevron.up")
            rightButton.setImage(image, for: .normal)
            viewAnimated(scene: "rightButtonUp")

        }
        onOffForRightButton = !onOffForRightButton
    }


    //MARK:- Library
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1: // 左
            webViewDisplay(bool: true)
            openUrl(urlForRegistrant: module.courceManagementHomeURL, urlForNotRegistrant: module.systemServiceListURL, alertTrigger: false)
        case 2: // 右
            webViewDisplay(bool: true)
            openUrl(urlForRegistrant: module.manabaURL, urlForNotRegistrant: module.eLearningListURL, alertTrigger: false)
        default:
            return
        }
    }
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        // 現在表示してるURL
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        module.displayURL = url.absoluteString
        
        print("displayURL : " + module.displayURL)
        
        // 許可するドメインを指定
        guard let host = navigationAction.request.url?.host else {
            return
        }
        if !host.contains(module.allowDomain){ // [tokushima-u.ac.jp] 以外はSafariで開く
            UIApplication.shared.open(URL(string: String(describing: module.displayURL))!)
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
        if (module.displayURL.contains(module.popupToYoutubeURL)){
            // Youtubeリンクを取得
            webView.evaluateJavaScript("document.linkform_iframe_balloon.url.value", completionHandler: { (html, error) -> Void in
                if let htmlYoutube = html{ // type(of: htmlYoutube) >>> __NSCFString
                    UIApplication.shared.open(URL(string: String(describing: htmlYoutube))!)
                    return
                }else{
                    webView.goBack()
                    self.alert(title: "エラー", message: "表示できませんでした")
                    return
                }
            })
        }
        
        // タイムアウト判定
        if (module.displayURL == module.timeOutURL){
            openUrl(urlForRegistrant: module.loginURL, urlForNotRegistrant: nil, alertTrigger: false)
        }
        
        decisionHandler(.allow)
        return
    }


    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // KeyChain
        let cAcaunt = dataManager.cAccount
        let passWord = dataManager.passWord

        // Login画面
        if (module.displayURL.contains(module.lostConnectionURL) && module.displayURL.suffix(2)=="s1"){ // 2回目は"=e1s2"
//            webView.isHidden = true
//            ActivityIndicator.startAnimating()
            webViewDisplay(bool: true)
            webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        }

        // 教務事務システム、アンケート催促スキップ
        if (module.displayURL == module.enqueteReminderURL){
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        }

        // シラバス
        if (module.displayURL.contains(module.syllabusURL) && !onlyOnceForSyllabusSearch){
            onlyOnceForSyllabusSearch = true
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(syllabusSubjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(syllabusTeacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(syllabusKeyword)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
        }
        
        // ハンバーガーメニューのボタン画像変更
        switch viewTopConfirmation() {
        case true:
            let image = UIImage(systemName: "line.horizontal.3")
            leftButton.setImage(image, for: .normal)
        
        case false:
            let image = UIImage(systemName: "arrowshape.turn.up.left")
            leftButton.setImage(image, for: .normal)
            
        }
        
        // WebView表示、非表示　判定
        webViewIsHidden()
        
    }


    // MARK: - Public func
    public func restoreView(){
        viewAnimated(scene: "restoreView")
    }
    
    /// 文字列で指定されたURLをWeb Viewを開く
    public func openUrl(urlForRegistrant: String, urlForNotRegistrant: String?, alertTrigger:Bool) {
        var url : String
        var trigger = alertTrigger
        url = urlForRegistrant
        if (urlForRegistrant.contains(module.libraryLoginURL)){
            webViewDisplay(bool: true)
        }
        
        // 登録者判定
        if (!registrantDecision()){
            if (url.contains(module.libraryLoginURL)){
                url = module.libraryHomeURL
                trigger = false
            }
            if let url1 = urlForNotRegistrant{
                url = url1
            }
            
            if (trigger) {
                alert(title: "利用できません", message: "設定からcアカウントとパスワードを登録してください")
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
        openUrl(urlForRegistrant: module.syllabusURL, urlForNotRegistrant: nil, alertTrigger: false)
        
//        webView.isHidden = true
//        ActivityIndicator.startAnimating()
        webViewDisplay(bool: true)
    }

    public func refresh(){
//        webView.isHidden = true
//        ActivityIndicator.startAnimating()
        webViewDisplay(bool: true)
        tabBarUnder.selectedItem = tabBarLeft
        openUrl(urlForRegistrant: module.loginURL, urlForNotRegistrant: module.systemServiceListURL, alertTrigger: false)
    }
    
    // MARK: - Private func
    
    private func webViewIsHidden(){
        // シラバス
        if (module.displayURL.contains(module.syllabusSearchMainURL)){
//            webView.isHidden = false
//            ActivityIndicator.stopAnimating()
            webViewDisplay(bool: false)
            return
        }
        // 登録者用　教務事務システム
        if (module.displayURL.contains(module.courceManagementHomeURL)){
//            webView.isHidden = false
//            ActivityIndicator.stopAnimating()
            webViewDisplay(bool: false)
            return
        }
        
        // 非登録者用　教務事務システム
        if (module.displayURL.contains(module.systemServiceListURL)){
//            webView.isHidden = false
//            ActivityIndicator.stopAnimating()
            webViewDisplay(bool: false)
            return
        }
        
        // マナバ
        if (module.displayURL.contains(module.manabaURL)){
//            webView.isHidden = false
//            ActivityIndicator.stopAnimating()
            webViewDisplay(bool: false)
            return
        }
        
        // 図書館
        if (module.displayURL.contains(module.libraryLoginURL)){
//            webView.isHidden = false
//            ActivityIndicator.stopAnimating()
            webViewDisplay(bool: false)
            return
        }
        
        if (module.displayURL.contains(module.syllabusURL)){
            if (onlyOnceForTimeSleep && onlyOnceForSyllabusPassdThrough){
                sleep(3)
//                webView.isHidden = false
//                ActivityIndicator.stopAnimating()
                webViewDisplay(bool: false)
                onlyOnceForTimeSleep = false
                onlyOnceForSyllabusPassdThrough = false
                return
            }else{
                onlyOnceForSyllabusPassdThrough = true
            }
        }
        
        // ログイン
        if (module.displayURL.contains(module.lostConnectionURL)){
            if (module.displayURL.suffix(2) != "s1"){ // ログインできなかった時
//                webView.isHidden = false
//                ActivityIndicator.stopAnimating()
                webViewDisplay(bool: false)
                return
            }
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
    
    private func alert(title:String, message:String) {
            alertController = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
            present(alertController, animated: true)
        }
    
    /// tabBar左ボタンの画像を入れ替える際の判定
    private func viewTopConfirmation() -> Bool {
        for url in module.topMenuURLs{
            if (module.displayURL.contains(url)){
                return true
            }
        }
        return false
    }
    
    func webViewDisplay(bool: Bool){
        switch bool {
        case true:
            webView.isHidden = true
            ActivityIndicator.startAnimating()
            
        case false:
            webView.isHidden = false
            ActivityIndicator.stopAnimating()
            
        }
        
    }
    
    /// アニメーション
    private func viewAnimated(scene:String){
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
}


