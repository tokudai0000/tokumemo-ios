//
//  HomeViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit
import FirebaseAnalytics

final class HomeViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adImageView: UIImageView!
    
    // 自動ログインをメイン画面(Home画面)中に完了させるために、サイズ0で表示はされないが読み込みや通信は行なっている。
    @IBOutlet weak var webViewForLogin: WKWebView!
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private let viewModel = HomeViewModel()
    private let dataManager = DataManager.singleton
    
    private var adTimer = Timer()
    private var loginGrayBackGroundView: UIView!
    private var weatherActivityIndicator: UIActivityIndicatorView!
    private var viewActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG || STUB
        // デバックの時にいじる部分
        //        dataManager.hadDoneTutorial = false // 毎回、チュートリアルを出現可能
        //        dataManager.agreementVersion = ""   // 毎回、利用規約同意画面を出現可能
        //        forLoginWebView.isHidden = false
        #endif
        
        initSetup()
        initViewModel()
        initActivityIndicator()
        viewModel.refleshAdImages()
        viewModel.getWether()
    }
    
    /// 画面が表示される直前
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 利用規約同意画面を表示するか判定
        if viewModel.shouldShowTermsAgreementView() {
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        // cellの内容を決定
        
        
        // Home画面が表示される度に、ログインページの読み込み
        relogin()
        
        // タイマーを開始する
        adTimerOn()
    }
    
    /// 画面が閉じる直前
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // タイマーを停止する(メモリの開放)
        adTimer.invalidate()
    }
    
    /// Viewがタップされた時
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            // weatherViewのtagは「1」に設定
            if touch.view?.tag == 1 {
                Analytics.logEvent("Button[Weather]", parameters: nil) // Analytics
                
                // 天気予報を表示させる
                let vc = R.storyboard.web.webViewController()!
                vc.loadUrlString = Url.weather.string()
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func studentCardButton(_ sender: Any) {
        Analytics.logEvent("Button[StudentCard]", parameters: nil) // Analytics
        
        if viewModel.isLoginComplete {
            let vc = R.storyboard.studentCard.studentCardViewController()!
            present(vc, animated: true, completion: nil)
        } else {
            toast(message: "Settings -> パスワード設定から自動ログイン機能をONにしましょう")
        }
    }
    
    // MARK: - Private func
    /// 初期セットアップ
    private func initSetup() {
        // collectionViewの初期設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // 1つのCell(xib)サイズを変更
        collectionView.collectionViewLayout = layout
        collectionView.register(R.nib.homeCollectionCell) // xibファイルを使うことを登録
        
        // webViewForLoginの初期設定
        webViewForLogin.navigationDelegate = self
        
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(R.color.mainColor())
    }
    
    /// ViewModel初期化
    private func initViewModel() {
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.state = { [weak self] (state) in
            
            guard let self = self else { fatalError() }
            
            DispatchQueue.main.async {
                switch state {
                    case .weatherBusy: // 通信中
                        self.weatherActivityIndicator.startAnimating() // クルクルスタート
                        break
                        
                    case .weatherReady: // 通信完了
                        self.weatherActivityIndicator.stopAnimating() // クルクルストップ
                        self.weatherViewLoad(discription: self.viewModel.weatherDiscription,
                                             feelsLike: self.viewModel.weatherFeelsLike,
                                             icon: UIImage(url: self.viewModel.weatherIconUrlStr))
                        break
                        
                    case .weatherError: // 通信失敗
                        self.weatherActivityIndicator.stopAnimating()
                        self.weatherViewLoad(discription: "取得エラー",
                                             feelsLike: "",
                                             icon: UIImage(resource: R.image.noImage)!)
                        break
                        
                    case .adBusy:
                        break
                        
                    case .adReady:
                        // 広告画像の表示
                        self.adImageView.cacheImage(imageUrlString: self.viewModel.adImage())
                        break
                        
                    case .adError:
                        break
                }
            }
        }
    }
    
    /// クルクル(読み込み中の表示)の初期設定
    private func initActivityIndicator() {
        weatherActivityIndicator = UIActivityIndicatorView()
        weatherActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        weatherActivityIndicator.center = self.weatherView.center // 天気情報を読み込む際に表示させる為

        // クルクルをストップした時に非表示する
        weatherActivityIndicator.hidesWhenStopped = true

        // 色を設定
        weatherActivityIndicator.style = UIActivityIndicatorView.Style.medium

        //Viewに追加
        self.weatherView.addSubview(weatherActivityIndicator)
        
        
        loginGrayBackGroundView = UIView()
        loginGrayBackGroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        loginGrayBackGroundView.backgroundColor = .gray.withAlphaComponent(0.25)
        //Viewに追加
        self.view.addSubview(loginGrayBackGroundView)
        
        
        viewActivityIndicator = UIActivityIndicatorView(style: .large)
        
        // クルクルをストップした時に非表示する
        viewActivityIndicator.hidesWhenStopped = true
        viewActivityIndicator.center = self.view.center
        
        // 色を設定
        viewActivityIndicator.color =  R.color.mainColor()
        
        //Viewに追加
        self.view.addSubview(viewActivityIndicator)
    }
    
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    private func relogin() {
        viewActivityIndicator.startAnimating() // クルクルスタート
        loginGrayBackGroundView.isHidden = false
        viewModel.updateLoginFlag(type: .loginStart)
        webViewForLogin.load(Url.universityTransitionLogin.urlRequest()) // 大学統合認証システムのログインページを読み込む
    }
    
    private func weatherViewLoad(discription: String, feelsLike: String, icon: UIImage) {
        weatherLabel.text = discription
        temperatureLabel.text = feelsLike
        weatherIconImageView.image = icon
    }
    
    private func adTimerOn() {
        var TIME_INTERVAL = 15.0 // 広告を表示させる秒数
        
        #if STUB // テスト時は5秒で表示が変わる様にする
        TIME_INTERVAL = 5.0
        #endif
        
        // TIME_INTERVAL秒毎に処理を実行する
        adTimer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL,
                                       repeats: true, block: { (timer) in
            // 広告画像の表示
            self.adImageView.cacheImage(imageUrlString: self.viewModel.adImage())
        })
    }
}


// MARK: - WebView
extension HomeViewController: WKNavigationDelegate {
    // ログイン用に使用するWebViewについての設定
    
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            AKLog(level: .FATAL, message: "読み込み前のURLがnil")
            viewActivityIndicator.stopAnimating() // クルクルストップ
            loginGrayBackGroundView.isHidden = true
            decisionHandler(.cancel)
            return
        }
        
        // ログインが完了しているか
        viewModel.checkLoginComplete(url.absoluteString)
        
        if !viewModel.hasRegisteredPassword() {
            viewModel.updateLoginFlag(type: .notStart)
        }
        
        // タイムアウトの判定
        if viewModel.isTimeout(urlStr: url.absoluteString) {
            relogin()
        }
        
        // ログインに失敗していた場合、通知
        if viewModel.isLoginFailure(url.absoluteString) {
            viewModel.updateLoginFlag(type: .loginMiss)
            toast(message: "学生番号もしくはパスワードが間違っている為、ログインできませんでした")
        }
        
        // ログイン完了時に鍵マークを外す(画像更新)為に、collectionViewのCellデータを更新
        if viewModel.isLoginCompleteImmediately {
            viewModel.updateLoginFlag(type: .loginSuccess)
            collectionView.reloadData()
        }
        
        if !viewModel.isLoginProcessing {
            viewActivityIndicator.stopAnimating() // クルクルストップ
            loginGrayBackGroundView.isHidden = true
        }
        
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let url = self.webViewForLogin.url! // fatalError
        AKLog(level: .DEBUG, message: url.absoluteString)
        
        // JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
        if viewModel.canExecuteJS(url.absoluteString) {
            // 徳島大学　統合認証システムサイト(ログインサイト)に自動ログインを行う。JavaScriptInjection
            webView.evaluateJavaScript("document.getElementById('username').value= '\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            
            // フラグ管理
            viewModel.updateLoginFlag(type: .executedJavaScript)
            return
        }
    }
}


// MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// セル数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectionLists.count
    }
    
    /// セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)! // fatalError
        
        let collectionList = viewModel.collectionLists[indexPath.row]
        
        let title = collectionList.title
        var icon = collectionList.iconSystemName! // fatalError
        
        // ログインが完了していないユーザーには鍵アイコンを表示(上書きする)
        if viewModel.isLoginComplete == false,
           let img = collectionList.lockIconSystemName {
            icon = img
        }
        
        cell.setupCell(title: title, image: icon)
        return cell
    }
    
    /// セルがタップされた時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップされたセルの内容を取得
        let cell = viewModel.collectionLists[indexPath.row]
        
        Analytics.logEvent("Cell[\(cell.id)]", parameters: nil) // Analytics
        
        // パスワード未登録、ロック画像ありのアイコン(ログインが必要)を押した場合
        if viewModel.hasRegisteredPassword() == false ,
           let _ = cell.lockIconSystemName {
            toast(message: "Settings -> パスワード設定から自動ログイン機能をONにしましょう")
            return
        }
        
        // 今年の成績だけ変化する為、保持する
        var loadUrlString = cell.url
        
        switch cell.id {
            case .syllabus:
                let vc = R.storyboard.syllabus.syllabusViewController()!
                vc.delegate = self
                present(vc, animated: true, completion: nil)
                
            case .currentTermPerformance: // 今年の成績
                loadUrlString = viewModel.createCurrentTermPerformanceUrl()
                
            case .libraryCalendar:
                libraryAlart()
                return
                
            default:
                break
        }
        
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = loadUrlString
        present(vc, animated: true, completion: nil)
    }
    
    /// 図書館では常三島と蔵本の2つのカレンダーを選択させるためにアラートを表示
    private func libraryAlart() {
        // 常三島と蔵本を選択させるpopup(**Alert**)を表示 **推奨されたAlertの使い方ではない為、修正すべき**
        var alert:UIAlertController!
        //アラートコントローラーを作成する。
        alert = UIAlertController(title: "", message: "図書館の所在を選択", preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(
            title: "常三島",
            style: UIAlertAction.Style.default,
            handler: { action in
                // 常三島のカレンダーURLを取得後、webView読み込み
                if let urlStr = self.viewModel.makeLibraryCalendarUrl(type: .main) {
                    let vcWeb = R.storyboard.web.webViewController()!
                    vcWeb.loadUrlString = urlStr
                    self.present(vcWeb, animated: true, completion: nil)
                }else{
                    AKLog(level: .ERROR, message: "[URL取得エラー]: 常三島開館カレンダー")
                    self.toast(message: "Error")
                }
            })
        
        let alertAction2 = UIAlertAction(
            title: "蔵本",
            style: UIAlertAction.Style.default,
            handler: { action in
                // 蔵本のカレンダーURLを取得後、webView読み込み
                if let urlStr = self.viewModel.makeLibraryCalendarUrl(type: .kura) {
                    let vcWeb = R.storyboard.web.webViewController()!
                    vcWeb.loadUrlString = urlStr
                    self.present(vcWeb, animated: true, completion: nil)
                }else{
                    AKLog(level: .ERROR, message: "[URL取得エラー]: 蔵本開館カレンダー")
                    self.toast(message: "Error")
                }
            })
        
        //アラートアクションを追加する。
        alert.addAction(alertAction)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion:nil)
    }
}
