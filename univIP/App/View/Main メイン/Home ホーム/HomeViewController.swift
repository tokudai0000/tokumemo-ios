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

final class HomeViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    // 自動ログインをメイン画面(Home画面)中に完了させるために、サイズ0で表示はされないが読み込みや通信は行なっている。
    @IBOutlet weak var forLoginWebView: WKWebView!
    
    private let viewModel = HomeViewModel()
    private let dataManager = DataManager.singleton
    private var timer = Timer()
    private var ActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        // デバックの時にいじる部分
//        dataManager.hadDoneTutorial = false // 毎回、チュートリアルを出現可能
//        dataManager.agreementVersion = ""   // 毎回、利用規約同意画面を出現可能
//        forLoginWebView.isHidden = false
        #endif
        
        initSetup()
        initViewModel()
        initActivityIndicator()
        adViewLoad()
        viewModel.getWether()
        
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(UIColor(red: 13/255, green: 58/255, blue: 151/255, alpha: 1.0))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 利用規約同意画面を表示するか判定
        if viewModel.shouldShowTermsAgreementView() {
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        // Home画面が表示される度に、ログインページの読み込み
        relogin()
        
    }
    
    // ステータスバーのスタイルを白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }

    // MARK: - IBAction
    @IBAction func studentCardButton(_ sender: Any) {
        Analytics.logEvent("Button[StudentCard]", parameters: nil) // Analytics
        
        // 学生証表示画面に遷移する
        if viewModel.isLoginComplete {
            let vc = R.storyboard.studentCard.studentCardViewController()!
            present(vc, animated: true, completion: nil)
            
        } else {
            toast(message: "Settings -> パスワード設定から自動ログイン機能をONにしましょう")
            
        }
    }
    
    // MARK: - Private func
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    private func relogin() {
        dataManager.canExecuteJavascript = true // ログイン用のJavaScriptを動かす為のフラグ
        viewModel.isLoginProcessing = true // ログイン処理中であるフラグ
        viewModel.isLoginComplete = false // ログインが完了したかのフラグ
        forLoginWebView.load(Url.universityTransitionLogin.urlRequest()) // 大学統合認証システムのログインページを読み込む
    }
    
    private func adViewLoad() {
        
        viewModel.getAdImages()
        
        let TIME_INTERVAL = 30.0
        var counter = 0
        
        adImageView.cacheImage(imageUrlString: self.viewModel.adImages[counter])
        counter += 1
        
        // TIME_INTERVAL秒毎に処理を実行する
        timer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL, repeats: true, block: { (timer) in
            if self.viewModel.adImages.count != counter {
                // 一定時間ごとに実行したい処理を記載する
                self.adImageView.cacheImage(imageUrlString: self.viewModel.adImages[counter])
                counter += 1
            } else {
                counter = 0
            }
            
        })
    }
    private func initSetup() {
        // collectionViewの初期設定
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // Cell(xib)のサイズを変更
        collectionView.collectionViewLayout = layout
        collectionView.register(R.nib.customCell) // xibファイルを使うことを登録
        
        // forLoginWebViewの初期設定
        forLoginWebView.navigationDelegate = self
    }
    
    private func initActivityIndicator() {
        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.weatherView.center
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        // 色を設定
        ActivityIndicator.style = UIActivityIndicatorView.Style.medium
        
        //Viewに追加
        self.weatherView.addSubview(ActivityIndicator)
    }
    
    private var alertController: UIAlertController!
    private func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - Public func

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
        if viewModel.isTimeOut(urlStr: url.absoluteString) {
            relogin()
        }
        
        // ログインが完了したか記録
        viewModel.isLoginComplete = viewModel.isLoginComplete(url.absoluteString)
        
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
        AKLog(level: .DEBUG, message: url.absoluteString)
        
        // JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
        if viewModel.canExecuteJS(url.absoluteString) {
            // 徳島大学　統合認証システムサイト(ログインサイト)
            // 自動ログインを行う。JavaScriptInjection
            webView.evaluateJavaScript("document.getElementById('username').value= '\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            
            // Dos攻撃を防ぐ為、1度ログインに失敗したら、JavaScriptを動かすフラグを下ろす
            dataManager.canExecuteJavascript = false
            viewModel.isLoginProcessing = true
            viewModel.isLoginComplete = false
            return
        }
        
        if viewModel.isLoginFailure(url.absoluteString) {
            toast(message: "学生番号もしくはパスワードが間違っている為、ログインできませんでした")
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// セクション内のセル数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ConstStruct.initCustomCellLists.count
    }
    
    /// セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.customCell, for: indexPath) else {
            AKLog(level: .FATAL, message: "CustomCellが見当たりません")
            fatalError()
        }
        
        cell.setupCell(string: viewModel.collectionLists[indexPath.row].title,
                       image: UIImage(systemName: viewModel.collectionLists[indexPath.row].iconSystemName!))
        
        
        // ログインが完了していないユーザーには鍵アイコンを表示(上書きする)
        if viewModel.isLoginComplete == false,
           let img = viewModel.collectionLists[indexPath.row].lockIconSystemName {
                cell.setupCell(string: viewModel.collectionLists[indexPath.row].title,
                               image: UIImage(systemName: img))
            
        }
        return cell
    }
    
    /// セルがタップされた時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップされたセルの内容を取得
        let cell = viewModel.collectionLists[indexPath.row]
        // アナリティクスを送信
        Analytics.logEvent("Cell[\(cell.id)]", parameters: nil) // Analytics
        
        // メールなどで再度入力したい場合があるため
        dataManager.canExecuteJavascript = true
        
        // パスワード未登録、ロック画像ありのアイコン(ログインが必要)を押した場合
        if viewModel.hasRegisteredPassword() == false ,
           let _ = cell.lockIconSystemName {
            alert(title: "自動ログイン機能がOFFです", message: "Settings -> パスワード設定から自動ログイン機能をONにしましょう")
            return
        }
        
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
                // MARK: - HACK 推奨されたAlertの使い方ではない
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
                return
                
            
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
                        // クルクルスタート
                        self.ActivityIndicator.startAnimating()
                        break
                        
                    case .ready: // 通信完了
                        // クルクルストップ
                        self.ActivityIndicator.stopAnimating()
                        
                        self.weatherLabel.text = self.viewModel.weatherDiscription
                        self.temperatureLabel.text = self.viewModel.weatherFeelsLike
                        self.weatherIconImageView.image = UIImage(url: self.viewModel.weatherIconUrlStr)
                        break
                        
                    case .error: // 通信失敗
                        // クルクルストップ
                        self.ActivityIndicator.stopAnimating()
                        self.weatherIconImageView.image = UIImage(named: "NoImage")
                        self.weatherLabel.text = "取得エラー"
                        break
                }
            }
        }
    }
}

// MARK: - Override(Animate)
extension HomeViewController {
    // メニューエリア以外タップ時、画面をMainViewに戻す
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // 画面をタップした時
        for touch in touches {
            // どの画面がタップされたかtagで判定
            if touch.view?.tag == 1 {
                Analytics.logEvent("Button[Weather]", parameters: nil) // Analytics
                let vcWeb = R.storyboard.web.webViewController()!
                vcWeb.loadUrlString = Url.weather.string()
                present(vcWeb, animated: true, completion: nil)
            }
        }
    }
}
