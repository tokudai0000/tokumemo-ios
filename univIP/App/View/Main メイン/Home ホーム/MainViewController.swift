//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit
import FirebaseAnalytics

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var weatherWebView: WKWebView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    // 自動ログインをメイン画面(Home画面)中に完了させるために、サイズ0で表示はされないが読み込みや通信は行なっている。
    @IBOutlet weak var forLoginWebView: WKWebView!
    
    private let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        // デバックの時にいじる部分
//        dataManager.hadDoneTutorial = false
//        dataManager.agreementVersion = ""
        #endif
        
        // collectionViewの初期設定
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
        collectionView.register(R.nib.customCell) // nibファイルを使うことを登録
        
        // forLoginWebViewの初期設定
        forLoginWebView.navigationDelegate = self
        
        // weatherWebViewの初期設定
        // (滅多に出ない雹や雪などの天気アイコンを作るよりWebページを表示した方が早いし正確との判断から)
        weatherWebView.load(URLRequest(url: URL(string: "https://www.jma.go.jp/bosai/forecast/img/201.svg")!)) // 気象庁のAPIから天気アイコンのURLを変更できるようにする
        weatherWebView.pageZoom = 3
        weatherWebView.isUserInteractionEnabled = false
        
        // フォアグラウンドの判定
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(foreground(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 利用規約同意画面を表示するべきか
        if viewModel.shouldShowTermsAgreementView {
            // 利用規約同意画面を表示
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        // ログインページの読み込み
        loadLoginPage()
    }
    
    // MARK: - IBAction
    @IBAction func studentCardButton(_ sender: Any) {
        Analytics.logEvent("Button[StudentCard]", parameters: nil) // Analytics
    }
    
    // MARK: - Private func
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    private func loadLoginPage() {
        // ログイン用のJavaScriptを動かす為のフラグ
        dataManager.canExecuteJavascript = true
        // ログイン処理中であるフラグ
        viewModel.isLoginProcessing = true
        // 大学統合認証システムのログインページを読み込む
        forLoginWebView.load(Url.universityTransitionLogin.urlRequest())
    }
    
    /// フォアグラウンド時の処理
    @objc private func foreground(notification: Notification) {
        viewModel.isLoginProcessing = true
        viewModel.isLoginComplete = false
        loadLoginPage()
    }
}


// MARK: - WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 読み込み前のURLをアンラップ
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            AKLog(level: .FATAL, message: "読み込み前のURLをアンラップ失敗")
            return
        }
        
        // タイムアウトした場合
        if viewModel.shouldReLogin(url.absoluteString) {
            // 再度ログイン処理を行う
            loadLoginPage()
        }
        
        // 問題ない場合読み込みを許可
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    ///
    /// 主に以下のことを処理する
    ///  1. JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 読み込み完了したURL
        let url = self.forLoginWebView.url! // fatalError
        
        // JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
        if viewModel.canJavaScriptExecute(url.absoluteString) {
            // 徳島大学　統合認証システムサイト(ログインサイト)
            // 自動ログインを行う。JavaScriptInjection
            webView.evaluateJavaScript("document.getElementById('username').value= '\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            
            // Dos攻撃を防ぐ為、1度ログインに失敗したら、JavaScriptを動かすフラグを下ろす
            dataManager.canExecuteJavascript = false
                
        }
        
        // ログインが完了したか記録
        viewModel.isLoginComplete = viewModel.isLoggedin(url.absoluteString)
        // ログイン完了時にcollectionViewのCellデータを更新
        if viewModel.isLoginCompleteImmediately {
            viewModel.isLoginCompleteImmediately = false
            collectionView.reloadData()
        }
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// セクション内のセル数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.initCustomCellLists.count
    }
    
    /// セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // どのnibファイルに紐づけるか
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.customCell, for: indexPath)
        
        if let cell = cell {

            cell.setupCell(string: viewModel.collectionLists[indexPath.row].title,
                            image: viewModel.collectionLists[indexPath.row].iconUnLock)
            
            if !viewModel.isLoginComplete {
                if let img = viewModel.collectionLists[indexPath.row].iconLock {
                    cell.setupCell(string: viewModel.collectionLists[indexPath.row].title,
                                   image: img)
                }
            }
            return cell
        }
        AKLog(level: .FATAL, message: "CustomCellが見当たりません")
        fatalError()
    }
    
    /// セルがタップされた時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップされたセルの内容を取得
        let cell = viewModel.collectionLists[indexPath.row]
        // アナリティクスを送信
        Analytics.logEvent("Cell[\(cell.id)]", parameters: nil) // Analytics
        
        dataManager.canExecuteJavascript = true
        
        // 押されたセルによって場合分け
        switch cell.id {
            case .syllabus:
                let vc = R.storyboard.syllabus.syllabusViewController()!
                vc.delegate = self
                present(vc, animated: true, completion: nil)

            case .currentTermPerformance: // 今年の成績
                let vc = R.storyboard.web.webViewController()!
                vc.loadUrlString = viewModel.createCurrentTermPerformanceUrl()
                present(vc, animated: true, completion: nil)
                return
                
            case .libraryCalendar:
                if let urlString = viewModel.makeLibraryCalendarUrl(type: .main) {
                    let vc = R.storyboard.web.webViewController()!
                    vc.loadUrlString = urlString
                    present(vc, animated: true, completion: nil)
                    return
                }
            
//            case .mailService:
                
            default:
                break
        }
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = cell.url
        present(vc, animated: true, completion: nil)
    }
}
