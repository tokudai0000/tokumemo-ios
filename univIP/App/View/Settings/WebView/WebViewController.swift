////
////  WebViewController.swift
////  univIP
////
////  Created by Akihiro Matsuyama on 2021/08/09.
////  Copyright © 2021年　akidon0000
////
//
//
///*
// JavaScript 要素取得方法
// https://qiita.com/amamamaou/items/25e8b4e1b41c8d3211f4
// */
//
//
//import UIKit
//import WebKit
//
//
//class MainViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate, UITabBarDelegate {
//    //MARK:- @IBOutlet
//    @IBOutlet weak var tabBarUnder: UITabBar!
//    @IBOutlet weak var webView: WKWebView!
//    @IBOutlet var viewTop: UIView!
//    @IBOutlet weak var rightButton: UIButton!
//
//    private let module = Module()
//
//    var url : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
//    var subjectName = ""
//    var teacherName = ""
//    var keyWord = ""
//    @IBOutlet weak var backButton: UIButton!{
//        didSet {
//            backButton.isEnabled = false
//            backButton.tintColor = UIColor.blue.withAlphaComponent(0.4)
//        }
//    }
//
//
//    //MARK:- LifeCycle
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
//        webView.isHidden = true
//        navigationItem.title = "あいう"
//        openUrl(urlString: url)
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        tabBarUnder.delegate = self
//        webView.navigationDelegate = self
//    }
//
//
//    //MARK:- @IBAction
//    @IBAction func settingsButton(_ sender: Any) {
//        if (module.displayURL == module.courceManagementHomeURL ||
//                module.displayURL == module.manabaURL ||
//                module.displayURL == module.syllabusURL ||
//                module.displayURL == module.liburaryURL){
//            // 表示時のアニメーションを作成する
//            UIView.animate(
//                withDuration: 0.5,
//                delay: 0.08,
//                options: .curveEaseOut,
//                animations: {
//                    self.viewTop.layer.position.x += 250
//                },
//                completion: { bool in
//                })
//            let vc = R.storyboard.settings.settingsViewController()!
//            self.present(vc, animated: false, completion: nil)
//            vc.delegateMain = self // restoreViewをSettingsVCから呼び出させるため
//
//        }else{
//            webView.goBack()
//        }
//
//
////        // 表示時のアニメーションを作成する
////        UIView.animate(
////            withDuration: 0.5,
////            delay: 0.08,
////            options: .curveEaseOut,
////            animations: {
////                self.viewTop.layer.position.x += 250
////        },
////            completion: { bool in
////        })
////        let vc = R.storyboard.settings.settingsViewController()!
////        self.present(vc, animated: false, completion: nil)
////        vc.delegateMain = self // restoreViewをSettingsVCから呼び出させるため
//    }
//
//    @IBAction func rightButton(_ sender: Any) {
//        if (module.once1){
//            let image = UIImage(systemName: "chevron.down")
//            rightButton.setImage(image, for: .normal)
//
//            // 表示時のアニメーションを作成する
//            UIView.animate(
//                withDuration: 0.5,
//                delay: 0.08,
//                options: .curveEaseOut,
//                animations: {
//                    self.webView.layer.position.y -= 60
//            },
//                completion: { bool in
//            })
//        }else{
//            let image = UIImage(systemName: "chevron.up")
//            rightButton.setImage(image, for: .normal)
//            // 表示時のアニメーションを作成する
//            UIView.animate(
//                withDuration: 0.5,
//                delay: 0.08,
//                options: .curveEaseOut,
//                animations: {
//                    self.webView.layer.position.y += 60
//            },
//                completion: { bool in
//            })
//        }
//        module.once1 = !module.once1
//    }
//
//
//    //MARK:- Librari
//
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        switch item.tag {
//        case 1:
//            openUrl(urlString: module.courceManagementHomeURL)
//        case 2:
//            openUrl(urlString: module.manabaURL)
//        default:
//            return
//        }
//    }
//
//    /// 読み込み設定（リクエスト前）
//    func webView(_ webView: WKWebView,
//                 decidePolicyFor navigationAction: WKNavigationAction,
//                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print(navigationAction.request.url!)
//
//        // 現在表示してるURL
//        if let url = navigationAction.request.url{
//            module.displayURL = url.absoluteString
//        }
//        decisionHandler(.allow)
//    }
//
//    /// 読み込み設定（レスポンス取得後）
//    func webView(_ webView: WKWebView,
//                 decidePolicyFor navigationResponse: WKNavigationResponse,
//                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        decisionHandler(.allow) // **必要**
//    }
//
//    /// 読み込み完了
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        DispatchQueue.main.async {
//            self.backButton.isEnabled = webView.canGoBack
//            self.backButton.tintColor = UIColor.blue.withAlphaComponent(webView.canGoBack ? 1.0 : 0.4)
//
////            self.forwardButton.isEnabled = webView.canGoForward
////            self.forwardButton.alpha = webView.canGoForward ? 1.0 : 0.4
//
//          }
//
//        let cAcaunt = "c611821006" //dataManager.cAccount
//        let passWord = "Akidon0326" //dataManager.passWord
//
//        if (module.hasPassdThroughOnce){
//            webView.isHidden = false
//        }
//
//        if (module.displayURL.prefix(82) == "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution"){
//            module.hasPassdThroughOnce = true
//            webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
//            webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
//            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
//        }
//
//        if (module.displayURL == "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"){
//            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
//            webView.isHidden = false
//        }
//
//        if (module.displayURL == module.syllabusURL){
//            if (module.once == false){
//                module.once = true
//                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(subjectName)'", completionHandler:  nil)
//                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(teacherName)'", completionHandler:  nil)
//                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(keyWord)'", completionHandler:  nil)
//                webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
//            }
//
//            webView.isHidden = false
//        }
//        if (module.displayURL == module.courceManagementHomeURL ||
//                module.displayURL == module.manabaURL ||
//                module.displayURL == module.syllabusURL ||
//                module.displayURL == module.liburaryURL){
//
//            let image = UIImage(systemName: "line.horizontal.3")
//            backButton.setImage(image, for: .normal)
//
//        }else{
//            let image = UIImage(systemName: "arrowshape.turn.up.left")
//            backButton.setImage(image, for: .normal)
//        }
//    }
//
//
//    // MARK: - Public func
//    public func restoreView(){
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0,
//            options: .curveEaseIn,
//            animations: {
//                self.viewTop.layer.position.x -= 250
//        },
//            completion: { bool in
//        })
//    }
//
//    public func reloadURL(urlString:String){
//        openUrl(urlString: urlString)
//    }
//    public func reloadSyllabus(subN:String, teaN:String, keW:String){
//        subjectName=subN
//        teacherName=teaN
//        keyWord=keW
//        module.once = false
//        openUrl(urlString: module.syllabusURL)
//
//    }
//
//    public func popupSyllabus(){
//        let vc = R.storyboard.syllabus.syllabusViewController()!
//        self.present(vc, animated: true, completion: nil)
//        vc.delegateMain = self
//    }
//    public func popupPassWordView(){
//        let vc = R.storyboard.passWordSettings.passWordSettingsViewController()!
//        self.present(vc, animated: true, completion: nil)
//    }
//
//    public func popupAboutThisApp(){
//        let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
//        self.present(vc, animated: true, completion: nil)
//    }
//
//    public func popupContactToDeveloper(){
//        let vc = R.storyboard.contactToDeveloper.contactToDeveloperViewController()!
//        self.present(vc, animated: true, completion: nil)
//    }
//
//    // MARK: - Private func
//    /// 文字列で指定されたURLをWeb Viewを開く
//    private func openUrl(urlString: String) {
//        let request = NSURLRequest(url: URL(string:urlString)!)
//        webView.load(request as URLRequest)
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//////
//////  WebViewController.swift
//////  univIP
//////
//////  Created by Akihiro Matsuyama on 2021/08/09.
//////  Copyright © 2021年　akidon0000
//////
////
////
/////*
//// JavaScript 要素取得方法
//// https://qiita.com/amamamaou/items/25e8b4e1b41c8d3211f4
//// */
////
////
////import UIKit
////import WebKit
////
////
////class WebViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate, UITabBarDelegate {
////    //MARK:- @IBOutlet
////    @IBOutlet weak var tabBarUnder: UITabBar!
////    @IBOutlet weak var webView: WKWebView!
////    @IBOutlet weak var navigationBar: UINavigationBar!
////    @IBOutlet var viewTop: UIView!
////
////    private let module = Module()
////    var url = ""
////
////    //MARK:- LifeCycle
////    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(false)
//////        webView.isHidden = true
////
////        openUrl(urlString: url)
////        restoreView()
////    }
////
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        tabBarUnder.delegate = self
////        webView.navigationDelegate = self
////    }
////
////
////    //MARK:- @IBAction
////    @IBAction func settingsButton(_ sender: Any) {
////        // 表示時のアニメーションを作成する
////        UIView.animate(
////            withDuration: 0.5,
////            delay: 0.08,
////            options: .curveEaseOut,
////            animations: {
////                self.viewTop.layer.position.x += 250
////        },
////            completion: { bool in
////        })
////        let vc = R.storyboard.settings.settingsViewController()!
////        self.present(vc, animated: false, completion: nil)
//////        vc.delegate = self // restoreViewをSettingsVCから呼び出させるため
////    }
////
////
////    //MARK:- Librari
////
////    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
////        switch item.tag {
////        case 1:
////            openUrl(urlString: module.courceManagementHomeURL)
////        case 2:
////            openUrl(urlString: module.manabaURL)
////        default:
////            return
////        }
////    }
////
////    /// 読み込み設定（リクエスト前）
////    func webView(_ webView: WKWebView,
////                 decidePolicyFor navigationAction: WKNavigationAction,
////                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
////        print(navigationAction.request.url!)
////
////        // 現在表示してるURL
////        if let url = navigationAction.request.url{
////            module.displayURL = url.absoluteString
////        }
////        decisionHandler(.allow)
////    }
////
////    /// 読み込み設定（レスポンス取得後）
////    func webView(_ webView: WKWebView,
////                 decidePolicyFor navigationResponse: WKNavigationResponse,
////                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
////        decisionHandler(.allow) // **必要**
////    }
////
////    /// 読み込み完了
////    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
////
////        let cAcaunt = "c611821006" //dataManager.cAccount
////        let passWord = "Akidon0326" //dataManager.passWord
////
////        if (module.hasPassdThroughOnce){
////            webView.isHidden = false
////        }
////
////        if (module.displayURL.prefix(82) == "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution"){
////            module.hasPassdThroughOnce = true
////            webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
////            webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
////            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
////        }
////
////        if (module.displayURL == "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"){
////            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
////            webView.isHidden = false
////        }
////
////
//////        webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(subjectName)'", completionHandler:  nil)
//////        webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(teacherName)'", completionHandler:  nil)
//////        webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_keyword_Search').value='\(keyWord)'", completionHandler:  nil)
//////        webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
////
////    }
////
////
////    // MARK: - Public func
////    public func restoreView(){
////        // メニューの位置を取得する
////        let menuPos = self.viewTop.layer.position
////        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
////        self.viewTop.layer.position.x = self.viewTop.frame.width
////        UIView.animate(
////            withDuration: 0.5,
////            delay: 0,
////            options: .curveEaseOut,
////            animations: {
////                self.viewTop.layer.position.x = menuPos.x
////        },
////            completion: { bool in
////        })
////    }
////
////
////    // MARK: - Private func
////    /// 文字列で指定されたURLをWeb Viewを開く
////    private func openUrl(urlString: String) {
////        let request = NSURLRequest(url: URL(string:urlString)!)
////        webView.load(request as URLRequest)
////    }
////}
////
////
