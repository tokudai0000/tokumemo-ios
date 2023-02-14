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
    @IBOutlet weak var weatherView: UIStackView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = HomeViewModel()
    let dataManager = DataManager.singleton
    var loginGrayBackGroundView: UIView!
    var viewActivityIndicator: UIActivityIndicatorView!
    
    private var adTimer = Timer()
    private var weatherActivityIndicator: UIActivityIndicatorView!
    
    
    // ステータスバーの文字を白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        layoutInitSetting()
        adImagesInitSetting()
        apiCommunicatingInitSeting()

        #if DEBUG
//        dataManager.agreementVersion = ""   // 利用規約同意画面を出現させたい場合
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.shouldShowTermsAgreementView() {
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
        
        if viewModel.shouldWebViewRelogin() {
            relogin() // 大学サイトへのログイン状況がタイムアウトになってるから
        }
         
        collectionView.reloadData() // カスタマイズ機能で並び替えを反映するため
        
        adRotationTimer(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adRotationTimer(false) // メモリの解放
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            // weatherViewがタップされた時 (tagは「1」に設定)
            if touch.view?.tag == 1 {
                let vc = R.storyboard.web.webViewController()!
                vc.loadUrlString = Url.weather.string()
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func studentCardButton(_ sender: Any) {
        if dataManager.isWebLoginCompleted {
            let vc = R.storyboard.studentCard.studentCardViewController()!
            present(vc, animated: true, completion: nil)
        } else {
            toast(message: "Settings -> パスワード設定から自動ログイン機能をONにしましょう")
        }
    }
    
    @objc func tappedAdImageView(_ sender: UITapGestureRecognizer) {
        guard viewModel.adDisplayUrl == "" else {
            return
        }
        
        let vc = R.storyboard.ad.adViewController()!
        vc.imageUrlStr = viewModel.adDisplayImages
        vc.urlStr = viewModel.adDisplayUrl
        present(vc, animated: true, completion: nil)
    }
    
    
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    func relogin() {
        viewActivityIndicator.startAnimating() // クルクルスタート
        loginGrayBackGroundView.isHidden = false
        viewModel.updateLoginFlag(type: .loginStart)
        webViewForLogin.load(Url.universityTransitionLogin.urlRequest()) // 大学統合認証システムのログインページを読み込む
    }
    
    // MARK: - Private func
                
    private func weatherViewLoad(discription: String, feelsLike: String, icon: UIImage) {
        weatherLabel.text = discription
        temperatureLabel.text = feelsLike
        weatherIconImageView.image = icon
    }
    
    private func adRotationTimer(_ type: Bool) {
        if type {
            // タイマーを開始する
            var TIME_INTERVAL = 5.0 // 広告を表示させる秒数
            
            #if DEBUG // テスト時は2秒で表示が変わる様にする
            TIME_INTERVAL = 2.0
            #endif
            
            // TIME_INTERVAL秒毎に処理を実行する
            adTimer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL,
                                           repeats: true, block: { (timer) in
                // 広告画像の表示
                self.adImageView.loadCacheImage(urlStr: self.viewModel.adImage())
            })
        }else{
            adTimer.invalidate()
        }
    }
    
    /// 初期セットアップ
    private func layoutInitSetting() {
        // collectionViewの初期設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // 1つのCell(xib)サイズを変更
        collectionView.collectionViewLayout = layout
        collectionView.register(R.nib.homeCollectionCell) // xibファイルを使うことを登録
        
        // webViewForLoginの初期設定
        webViewForLogin.navigationDelegate = self
        
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(R.color.mainColor())
        
        adImageView.isUserInteractionEnabled = true
        adImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedAdImageView(_:))))
        
        // クルクル(読み込み中の表示)の初期設定
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

    /// ViewModel初期化
    private func apiCommunicatingInitSeting() {
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
                        self.adImageView.loadCacheImage(urlStr: self.viewModel.adImage())
                        break
                        
                    case .adError:
                        break
                }
            }
        }
    }
    
    private func adImagesInitSetting() {
        viewModel.getAdItems()
    }
}
