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
        apiCommunicatingInitSetting()
        viewModel.getAdItems()
        viewModel.getWether()
        
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
        
        adImagesRotationTimer(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adImagesRotationTimer(false) // メモリの解放
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
        if dataManager.loginState.completed {
            let vc = R.storyboard.studentCard.studentCardViewController()!
            present(vc, animated: true, completion: nil)
        } else {
            toast(message: "Settings -> パスワード設定から自動ログイン機能をONにしましょう")
        }
    }
    
    @objc func tappedAdImageView(_ sender: UITapGestureRecognizer) {
        guard let num = viewModel.displayAdImagesNumber else {
            return
        }
        guard let image = viewModel.adItems[num].image else {
            return
        }
        guard let url = viewModel.adItems[num].url else {
            return
        }
        
        let vc = R.storyboard.ad.adViewController()!
        vc.imageUrlStr = image
        vc.urlStr = url
        present(vc, animated: true, completion: nil)
    }
    
    
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    func relogin() {
        viewActivityIndicator.startAnimating() // クルクルスタート
        loginGrayBackGroundView.isHidden = false
        viewModel.updateLoginFlag(type: .loginStart)
        webViewForLogin.load(Url.universityTransitionLogin.urlRequest())
    }
    
    
    // MARK: - Private func
    private func adImagesRotationTimer(_ type: Bool) {
        if type {
            var TIME_INTERVAL = 5.0 // 広告を表示させる秒数
            
            #if STUB
            TIME_INTERVAL = 2.0
            #endif
            
            // TIME_INTERVAL秒毎に処理を実行する
            adTimer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL,
                                           repeats: true,
                                           block: { (timer) in
                guard let num = self.viewModel.selectAdImageNumber() else {
                    return
                }
                guard let image = self.viewModel.adItems[num].image else {
                    return
                }
                self.viewModel.displayAdImagesNumber = num // 表示させてる広告の配列番号を覚える
                self.adImageView.loadCacheImage(urlStr: image) // 広告画像の表示
            })
            
        }else{
            adTimer.invalidate() // タイマー停止
        }
    }
    
    private func layoutInitSetting() {
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(R.color.mainColor())
        
        // collectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // 1つのCell(xib)サイズを変更
        collectionView.collectionViewLayout = layout
        collectionView.register(R.nib.homeCollectionCell) // xibファイルを使うことを登録
        
        // webViewForLogin
        webViewForLogin.navigationDelegate = self
        
        // adImageView
        adImageView.isUserInteractionEnabled = true // タップ無効
        adImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedAdImageView(_:))))
                
        // loginGrayBackGroundView(ログイン中の不透明画面表示)
        loginGrayBackGroundView = UIView()
        loginGrayBackGroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        loginGrayBackGroundView.backgroundColor = .gray.withAlphaComponent(0.25)
        self.view.addSubview(loginGrayBackGroundView)
        
        // viewActivityIndicator(ログイン中のクルクル)
        viewActivityIndicator = UIActivityIndicatorView(style: .large)
        viewActivityIndicator.hidesWhenStopped = true // クルクルをストップした時に非表示する
        viewActivityIndicator.center = self.view.center
        viewActivityIndicator.color =  R.color.mainColor() // 色を設定
        self.view.addSubview(viewActivityIndicator)
    }
    
    private func apiCommunicatingInitSetting() {
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.state = { [weak self] (state) in
            
            guard let self = self else { fatalError() }
            
            DispatchQueue.main.async {
                switch state {
                    case .weatherBusy: // 通信中
                        break
                        
                    case .weatherReady: // 通信完了
                        self.weatherLabel.text = self.viewModel.weatherData.description
                        self.temperatureLabel.text = self.viewModel.weatherData.feelsLike
                        self.weatherIconImageView.image = UIImage(url: self.viewModel.weatherData.iconUrlStr)
                        break
                        
                    case .weatherError: // 通信失敗
                        self.weatherLabel.text = "取得エラー"
                        self.temperatureLabel.text = ""
                        self.weatherIconImageView.image = UIImage(resource: R.image.noImage)!
                        break
                        
                    case .adBusy:
                        break
                        
                    case .adReady:
                        guard let num = self.viewModel.displayAdImagesNumber else {
                            return
                        }
                        guard let image = self.viewModel.adItems[num].image else {
                            return
                        }
                        // 広告画像の表示
                        self.adImageView.loadCacheImage(urlStr: image)
                        break
                        
                    case .adError:
                        break
                }
            }
        }
    }
}
