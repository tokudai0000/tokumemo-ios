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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tabBarUnder: UITabBar!
    @IBOutlet weak var rightButton: UIButton!
    
    private let module = Module()

    private var url : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
    private var subjectName = ""
    private var teacherName = ""
    private var keyWord = ""
    private var dataManager = DataManager()


    //MARK:- LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        webView.isHidden = true
        openUrl(urlString: url)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUnder.delegate = self
        webView.navigationDelegate = self
    }


    //MARK:- @IBAction
    @IBAction func settingsButton(_ sender: Any) {
        if (viewTopConfirmation()){
            let vc = R.storyboard.settings.settingsViewController()!
            self.present(vc, animated: false, completion: nil)
            vc.delegateMain = self // restoreViewをSettingsVCから呼び出させるため
        }else{
            webView.goBack()
        }
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
            openUrl(urlString: module.courceManagementHomeURL)
        case 2:
            openUrl(urlString: module.manabaURL)
        default:
            return
        }
    }

    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print(navigationAction.request.url!)

        // 現在表示してるURL
        if let url = navigationAction.request.url{
            module.displayURL = url.absoluteString
        }
        decisionHandler(.allow)
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
            openUrl(urlString: module.loginURL)
        }
        
        if (module.displayURL.prefix(83) == module.lostConnectionUrl){
            if (module.displayURL.suffix(2)=="s1"){ //2回目は"=e1s2"
                webView.isHidden = true
                webView.evaluateJavaScript("document.getElementById('username').value= '\(cAcaunt)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('password').value= '\(passWord)'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            }else{ // ログインできなかった時
                webView.isHidden = false
            }
        }

        if (module.displayURL == module.enqueteReminder){
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
        
        // ハンバーガーメニューのボタン画像変更
        var imageName = ""
        if (viewTopConfirmation()){
            imageName = "line.horizontal.3"
        }else{
            imageName = "arrowshape.turn.up.left"
        }
        let image = UIImage(systemName: imageName)
        backButton.setImage(image, for: .normal)
        
    }


    // MARK: - Public func
    public func restoreView(){
        viewAnimated(scene: "restoreView")
    }

    public func reloadURL(urlString:String){
        openUrl(urlString: urlString)
    }
    
    public func reloadSyllabus(subN:String, teaN:String, keyW:String, buttonTV:String){
        keyWord=keyW
        subjectName=subN
        teacherName=teaN
        module.onlySearchOnce = false
        openUrl(urlString: module.syllabusURL)
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
    private func openUrl(urlString: String) {
        let request = NSURLRequest(url: URL(string:urlString)!)
        webView.load(request as URLRequest)
    }
    
    private func viewTopConfirmation() -> Bool {
        if (module.displayURL == module.courceManagementHomeURL ||
                module.displayURL == module.manabaURL ||
                module.displayURL == module.syllabusURL ||
                module.displayURL == module.liburaryURL ||
                module.displayURL.prefix(83) == module.lostConnectionUrl){
            return true
        }else{
            return false
        }
    }
    
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


