//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit

final class MainViewController: UIViewController, WKUIDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var showServiceListsButton: UIButton!
    
    private let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        launchScreenAnimation()
        
        webView.load(viewModel.searchInitialViewUrl())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // 利用規約同意者か判定
        let hasAgreedTermsOfUse = (dataManager.agreementVersion == Constant.agreementVersion)
        
        if !hasAgreedTermsOfUse {
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func tappedBackButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func tappedForwardButton(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func showServiceListsButton(_ sender: Any) {
        let vc = R.storyboard.menu.menuViewController()!
        present(vc, animated: false, completion: nil)
        vc.delegate = self
    }
    
    
    // MARK: - Public func
    enum ModalViewType {
        case syllabus
        case cellSort
        case firstViewSetting
        case password
        case aboutThisApp
    }
    public func showModalView(type: ModalViewType){
        switch type {
        case .syllabus:
            let vc = R.storyboard.syllabus.syllabusViewController()!
            present(vc, animated: true, completion: nil)
            vc.delegate = self
            
        case .cellSort:
            let vc = R.storyboard.cellSort.cellSort()!
            present(vc, animated: true, completion: nil)
            
        case .firstViewSetting:
            let vc = R.storyboard.firstViewSetting.firstViewSetting()!
            present(vc, animated: true, completion: nil)
            
        case .password:
            let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
            present(vc, animated: true, completion: nil)
            vc.delegate = self
            
        case .aboutThisApp:
            let vc = R.storyboard.aboutThisApp.aboutThisApp()!
            present(vc, animated: true, completion: nil)
        }
    }
    
    /// シラバス検索ボタンを押された際
    public func refreshSyllabus(subjectName: String, teacherName: String) {
        viewModel.subjectName = subjectName
        viewModel.teacherName = teacherName
        guard let url = URL(string: Url.syllabus.string()) else {fatalError()}
        webView.load(URLRequest(url: url))
    }
    
    
    // MARK: - Private func
    private func launchScreenAnimation() {
        // 背景
        let launchScreenView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        launchScreenView.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1)
        launchScreenView.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        view.addSubview(launchScreenView)
        
        // 中心のicon
        let imageView = UIImageView(image: R.image.mainIconWhite())
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
        imageView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        view.addSubview(imageView)
        
        // 少し縮小する
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
            imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
                       completion: { (Bool) in }
        )
        
        // 拡大させて、消える
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
            imageView.transform = CGAffineTransform(scaleX: 100, y: 100)
            imageView.alpha = 1
        }, completion: { (Bool) in
            imageView.removeFromSuperview()
            launchScreenView.removeFromSuperview() }
        )
    }
    
    /// target="_blank" の処理
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
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
        
        guard let url = navigationAction.request.url else {
            AKLog(level: .ERROR, message: "リクエストエラー")
            decisionHandler(.cancel)
            return
        }
        
        // 現在読み込み中のURLを記録
        dataManager.displayUrlString = url.absoluteString
        
        if !viewModel.isAllowedDomainCheck() {
            AKLog(level: .DEBUG, message: "Safariで開く")
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        
        if viewModel.isJudgeUrl(type: .universityServiceTimeOut) {
            guard let url = URL(string: Url.manabaPC.string()) else {fatalError()}
            webView.load(URLRequest(url: url))
        }
        
        decisionHandler(.allow)
        return
    }
    
    
    // MARK: - 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if viewModel.isJudgeUrl(type: .universityLogin) {
            webView.evaluateJavaScript("document.getElementById('username').value= '\(DataManager.singleton.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(DataManager.singleton.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        }
        
        // 教務事務システム、アンケート催促スキップ
        if viewModel.isJudgeUrl(type: .questionnaireReminder) {
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ucTopEnqCheck_link_lnk').click();", completionHandler:  nil)
        }
        
        if viewModel.isJudgeUrl(type: .syllabusFirstTime) {
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_sbj_Search').value='\(viewModel.subjectName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_txt_staff_Search').value='\(viewModel.teacherName)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('ctl00_phContents_ctl06_btnSearch').click();", completionHandler:  nil)
        }
        
        if viewModel.isJudgeUrl(type: .outlookLogin) {
            webView.evaluateJavaScript("document.getElementById('userNameInput').value='\(dataManager.cAccount)@tokushima-u.ac.jp'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('passwordInput').value='\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('submitButton').click();", completionHandler:  nil)
        }
        
        if viewModel.isJudgeUrl(type: .tokudaiCareerCenter) {
            webView.evaluateJavaScript("document.getElementsByName('user_id')[0].value='\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByName('user_password')[0].value='\(dataManager.password)'", completionHandler:  nil)
        }
        
        // MARK: - HACK DispatchQueueの必要性 非同期にする必要あるか？
        DispatchQueue.main.async {
            self.goBackButton.isEnabled = webView.canGoBack
            self.goBackButton.alpha = webView.canGoBack ? 1.0 : 0.4
            self.goForwardButton.isEnabled = webView.canGoForward
            self.goForwardButton.alpha = webView.canGoForward ? 1.0 : 0.4
        }
    }
    
    
    /// alert対応
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        var messageText = message
        if dataManager.displayUrlString == Url.courseRegistration.string() { // 履修登録の追加ボタンを押す際、ブラウザのポップアップブロックを解除せよとのalertが出る(必要ない)
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
