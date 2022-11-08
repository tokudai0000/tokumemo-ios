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

final class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var weatherWebView: WKWebView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    // 自動ログインをメイン画面(Home画面)中に完了させるために、サイズ0で表示はされないが読み込みや通信は行なっている。
    @IBOutlet weak var forLoginWebView: WKWebView!
    
    private let viewModel = HomeViewModel()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        // デバックの時にいじる部分
//        dataManager.hadDoneTutorial = false // 毎回、チュートリアルを出現可能
//        dataManager.agreementVersion = ""   // 毎回、利用規約同意画面を出現可能
        #endif
        
        // collectionViewの初期設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // Cell(xib)のサイズを変更
        collectionView.collectionViewLayout = layout
        collectionView.register(R.nib.customCell) // xibファイルを使うことを登録
        
        // forLoginWebViewの初期設定
        forLoginWebView.navigationDelegate = self
        
        viewModel.getWetherData()
        weatherWebView.isUserInteractionEnabled = false
        
        // フォアグラウンドの判定
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(foreground(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(.white)
        
        initViewModel()
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
        
        dateLabel.text = dateToday()
    }
    func dateToday () -> String {
        let dt = Date()
        let dateFormatter = DateFormatter()
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        
        return dateFormatter.string(from: dt)
    }
    // MARK: - IBAction
    @IBAction func studentCardButton(_ sender: Any) {
        Analytics.logEvent("Button[StudentCard]", parameters: nil) // Analytics
        
        // ボタンが押されたときにStudentCard.storyboardに遷移する
        let vc = R.storyboard.studentCard.studentCardViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Private func
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    private func loadLoginPage() {
        // ログイン用のJavaScriptを動かす為のフラグ
        dataManager.canExecuteJavascript = true
        // ログイン処理中であるフラグ
        viewModel.isLoginProcessing = true
        // ログインが完了したかのフラグ
        viewModel.isLoginComplete = false
        // 大学統合認証システムのログインページを読み込む
        forLoginWebView.load(Url.universityTransitionLogin.urlRequest())
    }
    
    /// フォアグラウンド時の処理
    /// アプリを30分後などに再度開いて使用すると、ログアウトされている状態になっている。
    /// 30分後であれば再ログインなど実装してみたものの、うまく動かなかった為、毎度ログインする様にしている。
    /// しかし、トークンが有効な状態であれば、ログイン画面へは行かずに教務事務システムの画面へ遷移してくれる。(サーバー側の機能)
    @objc private func foreground(notification: Notification) {
        loadLoginPage()
    }
}


// MARK: - WKNavigationDelegate
extension HomeViewController: WKNavigationDelegate {
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
        
        // 再度ログインを行う必要があるのか判定(タイムアウト)
        if viewModel.shouldReLogin(url.absoluteString) {
            loadLoginPage()
        }
        
        // ログインが完了したか記録
        viewModel.isLoginComplete = viewModel.isLoggedin(url.absoluteString)
        
        // ログイン完了時にcollectionViewのCellデータを更新
        if viewModel.isLoginCompleteImmediately {
            viewModel.isLoginCompleteImmediately = false
            collectionView.reloadData()
        }
        
        // 読み込みを許可
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
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
            viewModel.isLoginProcessing = true
            viewModel.isLoginComplete = false
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// セクション内のセル数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.initCustomCellLists.count
    }
    
    /// セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.customCell, for: indexPath) else {
            AKLog(level: .FATAL, message: "CustomCellが見当たりません")
            fatalError()
        }
        
        cell.setupCell(string: viewModel.collectionLists[indexPath.row].title,
                        image: viewModel.collectionLists[indexPath.row].iconUnLock)
        
        // ログインが完了していないユーザーには鍵アイコンを表示(上書きする)
        if viewModel.isLoginComplete == false {
            if let img = viewModel.collectionLists[indexPath.row].iconLock {
                cell.setupCell(string: viewModel.collectionLists[indexPath.row].title,
                               image: img)
            }
        }
        return cell
    }
    
    /// セルがタップされた時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップされたセルの内容を取得
        let cell = viewModel.collectionLists[indexPath.row]
        // アナリティクスを送信
        Analytics.logEvent("Cell[\(cell.id)]", parameters: nil) // Analytics
        
        // メールなどで再度入力したい場合がある
        dataManager.canExecuteJavascript = true
        
        let vcWeb = R.storyboard.web.webViewController()!
        var loadUrlString = cell.url
        // 押されたセルによって場合分け
        switch cell.id {
            case .syllabus:
                let vc = R.storyboard.syllabus.syllabusViewController()!
                vc.delegate = self
                present(vc, animated: true, completion: nil)

            case .currentTermPerformance: // 今年の成績
                loadUrlString = viewModel.createCurrentTermPerformanceUrl()
                
            case .libraryCalendar:
                guard let urlString = viewModel.makeLibraryCalendarUrl(type: .main) else {
                    return
                }
                loadUrlString = urlString
                
            
//            case .mailService:
                
            default:
                break
        }
        vcWeb.loadUrlString = loadUrlString
        present(vcWeb, animated: true, completion: nil)
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
                        break
                        
                    case .ready: // 通信完了
                        
                        self.weatherLabel.text = self.viewModel.weatherDataDiscription
                        self.temperatureLabel.text = self.viewModel.weatherDataFeelLike
                        if let url = URL(string: self.viewModel.weatherDataIconUrlStr) {
                            self.weatherWebView.load(URLRequest(url: url))
                        }
                        
                        break
                        
                    case .error:
                        break
                        
                }
            }
        }
    }
}
