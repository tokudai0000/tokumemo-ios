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


final class MainViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate, UITabBarDelegate {
    //MARK:- @IBOutlet
    @IBOutlet var viewTop: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tabBarUnder: UITabBar!
    @IBOutlet weak var tabBarLeft: UITabBarItem!
    
    var launchScreenView: UIView!
    var launchScreenImage: UIImage!
    private let module = Module()
    private var alertController: UIAlertController!
    private var url : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
    private var subjectName = ""
    private var teacherName = ""
    private var keyWord = ""
    private var dataManager = DataManager()

    override func loadView() {
        super.loadView()
//        print("loadView")
        viewAnimated(scene: "launchScreen")
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
//        viewAnimated(scene: "launchScreen")
        // 初期時選択状態
        tabBarUnder.selectedItem = tabBarLeft
        webView.isHidden = true
//        webView.frame = view.frame
        
//        if (registrantDecision()){
//            openUrl(urlString: url)
//        }else{
//            openUrl(urlString: module.systemServiceListURL)
//        }
        openUrl(urlForRegistrant: url, urlForNotRegistrant: module.systemServiceListURL, alertTrigger: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUnder.delegate = self
        webView.navigationDelegate = self
        webView.isUserInteractionEnabled = true
        
//        openUrl(urlString: module.systemServiceListURL)
    }


    //MARK:- @IBAction
    @IBAction func leftButton(_ sender: Any) {
        if (viewTopConfirmation()){
            let vc = R.storyboard.settings.settingsViewController()!
            self.present(vc, animated: false, completion: nil)
//            viewAnimated(scene: "mainToSettings")
            vc.delegateMain = self // restoreViewをSettingsVCから呼び出させるため
        }else{
            webView.goBack()
        }
    }
    
    @IBAction func centerButton(_ sender: Any) {
        tabBarUnder.selectedItem = tabBarLeft
        openUrl(urlForRegistrant: module.loginURL, urlForNotRegistrant: module.systemServiceListURL, alertTrigger: false)
//        if (registrantDecision()){
//            openUrl(urlString: module.loginURL)
//        }else{
//            openUrl(urlString: module.systemServiceListURL)
//        }
    }
    

    @IBAction func rightButton(_ sender: Any) {
        var imageName : String
        var animationName : String
        
        if (module.mainViewRightButtonOnOff){
            imageName = "chevron.down"
            animationName = "rightButtonDown"
        }else{
            imageName = "chevron.up"
            animationName = "rightButtonUp"
        }
        
        let image = UIImage(systemName: imageName)
        rightButton.setImage(image, for: .normal)
        viewAnimated(scene: animationName)
        
        module.mainViewRightButtonOnOff = !module.mainViewRightButtonOnOff
    }


    //MARK:- Library
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            openUrl(urlForRegistrant: module.courceManagementHomeURL, urlForNotRegistrant: module.systemServiceListURL, alertTrigger: false)
        case 2:
            openUrl(urlForRegistrant: module.manabaURL, urlForNotRegistrant: module.eLearningListURL, alertTrigger: false)
        default:
            return
        }

//        if (registrantDecision()){
//            switch item.tag {
//            case 1:
//                openUrl(urlString: module.courceManagementHomeURL)
//            case 2:
//                openUrl(urlString: module.manabaURL)
//            default:
//                return
//            }
//        }else{
//            switch item.tag {
//            case 1:
//                openUrl(urlString: module.systemServiceListURL)
//            case 2:
//                openUrl(urlString: module.eLearningListURL)
//            default:
//                return
//            }
//        }
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
//        if let url = navigationAction.request.url{
        module.displayURL = url.absoluteString
        
        // <a href="..." target="_blank"> が押されたとき
        if (navigationAction.navigationType == .linkActivated){
            if navigationAction.targetFrame == nil
                || !navigationAction.targetFrame!.isMainFrame {
//                    openUrl(urlString: url.absoluteString)
                openUrl(urlForRegistrant: url.absoluteString, urlForNotRegistrant: nil, alertTrigger: false)
                decisionHandler(.cancel)
                return
            }
        }
//        }
        
        if (url == URL(string: module.popupToYoutubeURL)){
            webView.evaluateJavaScript("document.linkform_iframe_balloon.url.value", completionHandler: { (html, error) -> Void in
                print(html!)
                if let htmlYoutube = html{
//                    print(type(of: htmlYoutube))
                    UIApplication.shared.openURL(URL(string: String(describing: htmlYoutube))!)
//                    self.openUrl(urlForRegistrant: String(describing: htmlYoutube), urlForNotRegistrant: nil, alertTrigger: false)
                }
            })
        }
        print(navigationAction.request.url!)


        
        // 許可するドメインを指定
        guard let host = navigationAction.request.url?.host else {
            return
        }
//        if let host = navigationAction.request.url?.host{
        if host.contains(module.allowDomain){
            decisionHandler(.allow)
            return
        }
//        }
//        if UIApplication.shared.responds(to: #selector(UIApplication.open(_:options:completionHandler:))) {
//            UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly:false], completionHandler: { (finished: Bool) in
//            })
//        }
//        else {
//            // iOS 10 で deprecated 必要なら以降のopenURLも振り分ける
//            // iOS 10以降は UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            UIApplication.shared.openURL(url)
//        }
        UIApplication.shared.openURL(url)
        decisionHandler(.cancel)
        return
//        UIApplication.shared.open(navigationAction.request.url!)
//        decisionHandler(.cancel)
    }

    /// 読み込み設定（レスポンス取得後）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow) // **必要**
    }

    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let cAcaunt = dataManager.cAccount
        let passWord = dataManager.passWord

        if (module.displayURL == module.timeOutURL){
//            openUrl(urlString: module.loginURL)
            openUrl(urlForRegistrant: module.loginURL, urlForNotRegistrant: nil, alertTrigger: false)
        }
        
        if (module.displayURL.prefix(83) == module.lostConnectionURL){
            if (module.displayURL.suffix(2)=="s1"){ //2回目は"=e1s2"
                webView.isHidden = true
                webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            }else{ // ログインできなかった時
                webView.isHidden = false
            }
        }

        if (module.displayURL == module.enqueteReminderURL){
            webView.isHidden = false
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        }

        if (module.displayURL == module.syllabusURL){
            webView.isHidden = false
            if (module.onlySearchOnce == false){
                module.onlySearchOnce = true
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(subjectName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(teacherName)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(keyWord)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
            }
        }
        
        if (viewTopConfirmation()){
            webView.isHidden = false
        }
        
        
        // ハンバーガーメニューのボタン画像変更
        var imageName = ""
        if (viewTopConfirmation()){
            imageName = "line.horizontal.3"
        }else{
            imageName = "arrowshape.turn.up.left"
        }
        let image = UIImage(systemName: imageName)
        leftButton.setImage(image, for: .normal)
        
    }


    // MARK: - Public func
    public func restoreView(){
        viewAnimated(scene: "restoreView")
    }

    public func reloadURL(urlString:String){
        openUrl(urlForRegistrant: urlString, urlForNotRegistrant: module.libraryHomeURL, alertTrigger: true)
//        if (registrantDecision()){
//            openUrl(urlString: urlString)
//        }else{
//            if (urlString == module.liburaryLoginURL){
//                openUrl(urlString: module.libraryHomeURL)
//            }else{
//                alert(title: "利用できません", message: "設定からcアカウントとパスワードを登録してください")
//            }
//        }
    }
    
    public func reloadSyllabus(subN:String, teaN:String, keyW:String, buttonTV:String){
        keyWord=keyW
        subjectName=subN
        teacherName=teaN
        module.onlySearchOnce = false
//        openUrl(urlString: module.syllabusURL)
        openUrl(urlForRegistrant: module.syllabusURL, urlForNotRegistrant: nil, alertTrigger: false)
    }

    public func popupSyllabus(){
        let vc = R.storyboard.syllabus.syllabusViewController()!
        self.present(vc, animated: true, completion: nil)
        vc.delegateMain = self
    }
    public func popupPassWordView(){
        let vc = R.storyboard.passWordSettings.passWordSettingsViewController()!
        self.present(vc, animated: true, completion: nil)
        vc.delegateMain = self
    }
    public func popupAboutThisApp(){
        let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    public func popupContactToDeveloper(){
        let vc = R.storyboard.contactToDeveloper.contactToDeveloperViewController()!
        self.present(vc, animated: true, completion: nil)
    }

    
    // MARK: - Private func
    /// 文字列で指定されたURLをWeb Viewを開く
    private func openUrl(urlForRegistrant: String, urlForNotRegistrant: String?, alertTrigger:Bool) {
        var url : String
        url = urlForRegistrant
        if (!registrantDecision()){
            if let url1 = urlForNotRegistrant{
                url = url1
            }
            if (alertTrigger) {
                if (urlForNotRegistrant == module.displayURL){
                    alert(title: "利用できません", message: "設定からcアカウントとパスワードを登録してください")
                }
            }
        }
        let request = NSURLRequest(url: URL(string:url)!)
        
        webView.load(request as URLRequest)
    }
//    private func openUrl(urlString: String) {
//        let request = NSURLRequest(url: URL(string:urlString)!)
//        webView.load(request as URLRequest)
//    }
    
    /// アカウント登録者ならtrue
    private func registrantDecision() -> Bool{
        if (dataManager.cAccount != "" &&
                dataManager.passWord != ""){
            return true
        }else{
            return false
        }
    }
    
    func alert(title:String, message:String) {
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
            if (module.displayURL == url || module.displayURL.prefix(83) == url){
                return true
            }
        }
        return false
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
                delay: 2.0,
                options: UIView.AnimationOptions.curveEaseOut,
                animations: { () in
                    imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }, completion: { (Bool) in

            })

            //拡大させて、消えるアニメーション
            UIView.animate(withDuration: 0.5,
                delay: 2.3,
                options: UIView.AnimationOptions.curveEaseOut,
                animations: { () in
                    imageView.transform = CGAffineTransform(scaleX: 50, y: 50)
                    imageView.alpha = 0.1
                }, completion: { (Bool) in
                    imageView.removeFromSuperview()
                    self.launchScreenView.removeFromSuperview()
            })
//            UIView.animate(
//                withDuration: 5,
//                delay: 0,
//                options: .curveEaseIn,
//                animations: {
//                    imageView.layer.position.x = +200
//                },
//                completion: { bool in
//                    //                    self.dismiss(animated: false, completion: nil)
//                }
//            )
            
//        case "mainToSettings":
//            UIView.animate(
//                withDuration: 5,
//                delay: 0,
//                options: .curveEaseIn,
//                animations: {
//                    self.viewTop.layer.position.x = +200
////                    self.viewTop.layer.position.x = -self.viewTop.frame.width
//                },
//                completion: { bool in
////                    self.dismiss(animated: false, completion: nil)
//                }
//            )
            
//            let menuPos = self.viewTop.layer.position
//            print(menuPos)
//            self.viewTop.center = self.view.center
////            self.viewTop.layer.position.x = 1000
//            UIView.animate(
//                withDuration: 10,
//                delay: 0,
//                options: .curveEaseIn,
//                animations: {
////                    self.viewTop.layer.position.x += 100
//                },
//                completion: { _ in
//                    self.viewTop.layer.position.x += 100
//                })
//        case "settingsViewAppear":
//            // メニューの位置を取得する
//            let menuPos = self.tableView.layer.position
//            // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
//            self.tableView.layer.position.x = -self.tableView.frame.width
//            UIView.animate(
//                withDuration: 10,
//                delay: 0,
//                options: .curveEaseOut,
//                animations: {
//                    self.tableView.layer.position.x = menuPos.x
//            },
//                completion: { bool in
//            })
//        case "restorView":
//                // 表示時のアニメーションを作成する
//                UIView.animate(
//                    withDuration: 0.5,
//                    delay: 0.08,
//                    options: .curveEaseOut,
//                    animations: {
//                        self.viewTop.layer.position.x += 250
//                },
//                    completion: { bool in
//                })
//                let vc = R.storyboard.settings.settingsViewController()!
//                self.present(vc, animated: false, completion: nil)
//                vc.delegateMain = self // restoreViewをSettingsVCから呼び出させるため
        default:
            return
        }
    }
}


