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
    @IBOutlet weak var tabBarLeft: UITabBarItem!
    
    private let module = Module()

    var alertController: UIAlertController!
    private var url : String = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
    private var subjectName = ""
    private var teacherName = ""
    private var keyWord = ""
    private var dataManager = DataManager()


 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // 初期時選択状態
        tabBarUnder.selectedItem = tabBarLeft
        webView.isHidden = true
        
        if (registrantDecision()){
            openUrl(urlString: url)
        }else{
            openUrl(urlString: module.systemServiceList)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUnder.delegate = self
        webView.navigationDelegate = self
        
        openUrl(urlString: module.systemServiceList)
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
        if (registrantDecision()){
            switch item.tag {
            case 1:
                openUrl(urlString: module.courceManagementHomeURL)
            case 2:
                openUrl(urlString: module.manabaURL)
            default:
                return
            }
        }else{
            switch item.tag {
            case 1:
                openUrl(urlString: module.systemServiceList)
            case 2:
                openUrl(urlString: module.eLearningList)
            default:
                return
            }
        }
    }
    
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        // 現在表示してるURL
        if let url = navigationAction.request.url{
            module.displayURL = url.absoluteString
            
            // <a href="..." target="_blank"> が押されたとき
            if (navigationAction.navigationType == .linkActivated){
                if navigationAction.targetFrame == nil
                    || !navigationAction.targetFrame!.isMainFrame {
                    openUrl(urlString: url.absoluteString)
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        
        
        print(navigationAction.request.url!)


        
        // 許可するドメインを指定
        if let host = navigationAction.request.url?.host {
            for url in module.allowDomeins{
                if host.contains(url) {
                    decisionHandler(.allow)
                    return
                }else{
                    continue
                }
            }
        }
        decisionHandler(.cancel)
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
        backButton.setImage(image, for: .normal)
        
    }


    // MARK: - Public func
    public func restoreView(){
        viewAnimated(scene: "restoreView")
    }

    public func reloadURL(urlString:String){
        if (registrantDecision()){
            openUrl(urlString: urlString)
        }else{
            if (urlString == module.liburaryURL){
                openUrl(urlString: module.libraryHomeURL)
            }else{
                alert(title: "利用できません", message: "設定からcアカウントとパスワードを登録してください")
            }
        }
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
        if (module.displayURL == module.courceManagementHomeURL ||
                module.displayURL == module.manabaURL ||
                module.displayURL == module.syllabusURL ||
                module.displayURL == module.liburaryURL ||
                module.displayURL == module.systemServiceList ||
                module.displayURL == module.eLearningList ||
                module.displayURL == module.libraryHomeURL ||
                module.displayURL.prefix(83) == module.lostConnectionUrl){
            return true
        }else{
            return false
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


