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

final class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var adContainerView: UIView!
    @IBOutlet weak var adImageView: UIImageView!
    
    // 自動ログインをメイン画面(Home画面)中に完了させるために、サイズ0で表示はされないが読み込みや通信は行なっている。
    @IBOutlet weak var webViewForLogin: WKWebView!
    @IBOutlet weak var weatherView: UIStackView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // extensionで別ファイルから呼び出し
    let viewModel = HomeViewModel()
    let dataManager = DataManager.singleton
    var loginGrayBackGroundView: UIView! // ログイン中のグレー背景
    var viewActivityIndicator: UIActivityIndicatorView! // ログイン中のクルクル
    
    // MARK: - Override
    // キーボード非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
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
        
        adImagesRotationTimerON()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adTimer.invalidate() // タイマー停止
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
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = Url.contactUs.string()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func tappedAdImageView(_ sender: UITapGestureRecognizer) {
        guard let num = viewModel.displayAdImagesNumber,
              let image = viewModel.adItems[num].image,
              let url = viewModel.adItems[num].url else {
            return
        }
        let vc = R.storyboard.ad.adViewController()!
        vc.imageUrlStr = image
        vc.urlStr = url
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Public func
    public var isToastShow : Bool {
        get {
            return toastView == nil ? false : true
        }
    }
    private var toastView:UIView?
    private var toastShowFrame:CGRect = .zero
    private var toastHideFrame:CGRect = .zero
    private var toastInterval:TimeInterval = 3.0
    /// トースト表示
    ///
    /// - Parameters:
    ///   - message: メッセージ
    ///   - interval: 表示時間（秒）デフォルト3秒
    public func toast( message: String, type: String = "highBottom", interval:TimeInterval = 3.0 ) {
        guard self.toastView == nil else {
            return // 既に表示準備中
        }
        self.toastView = UIView()
        guard let toastView = self.toastView else { // アンラッピング
            return
        }
        
        toastInterval = interval
        
        switch type {
        case "top":
            toastShowFrame = CGRect(x: 15,
                                    y: 8,
                                    width: self.view.frame.width - 15 - 15,
                                    height: 46)
            
            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
                                    y: 0 - toastShowFrame.height * 2,  // 上に隠す
                                    width: toastShowFrame.width,
                                    height: toastShowFrame.height)
            
        case "bottom":
            toastShowFrame = CGRect(x: 15,
                                    y: self.view.frame.height - 100,
                                    width: self.view.frame.width - 15 - 15,
                                    height: 46)
            
            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
                                    y: self.view.frame.height - toastShowFrame.height * 2,  // 上に隠す
                                    width: toastShowFrame.width,
                                    height: toastShowFrame.height)
            
        case "highBottom":
            toastShowFrame = CGRect(x: 15,
                                    y: self.view.frame.height - 180,
                                    width: self.view.frame.width - 15 - 15,
                                    height: 46)
            
            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
                                    y: self.view.frame.height - toastShowFrame.height * 2,  // 上に隠す
                                    width: toastShowFrame.width,
                                    height: toastShowFrame.height)
        default:
            return
        }
        
        
        toastView.frame = toastHideFrame  // 初期隠す位置
        toastView.backgroundColor = UIColor.black
        toastView.alpha = 0.8
        toastView.layer.cornerRadius = 18
        self.view.addSubview(toastView)
        
        let labelWidth:CGFloat = toastView.frame.width - 14 - 14
        let labelHeight:CGFloat = 19.0
        let label = UILabel()
        // toastView内に配置
        label.frame = CGRect(x: 14,
                             y: 14,
                             width: labelWidth,
                             height: labelHeight)
        toastView.addSubview(label)
        // label属性
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 0 // 複数行対応
        label.text = message
        //"label.frame1: \(label.frame)")
        // 幅を制約して高さを求める
        label.frame.size = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        //print("label.frame2: \(label.frame)")
        // 複数行対応・高さ変化
        if labelHeight < label.frame.height {
            toastShowFrame.size.height += (label.frame.height - labelHeight)
        }
        
        didHideIndicator()
    }
    
    @objc private func didHideIndicator() {
        guard let toastView = self.toastView else { // アンラッピング
            return
        }
        DispatchQueue.main.async { // 非同期処理
            UIView.animate(withDuration: 0.5, animations: { () in
                // 出現
                toastView.frame = self.toastShowFrame
            }) { (result) in
                // 出現後、interval(秒)待って、
                DispatchQueue.main.asyncAfter(deadline: .now() + self.toastInterval) {
                    UIView.animate(withDuration: 0.5, animations: { () in
                        // 消去
                        toastView.frame = self.toastHideFrame
                    }) { (result) in
                        // 破棄
                        toastView.removeFromSuperview()
                        self.toastView = nil // 破棄
                    }
                }
            }
        }
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
    private var adTimer = Timer()
    /// 広告を一定時間ごとに読み込ませる処理のスイッチ
    private func adImagesRotationTimerON() {
        var TIME_INTERVAL = 5.0 // 広告を表示させる秒数
        
        #if STUB
        TIME_INTERVAL = 2.0
        #endif
        
        // TIME_INTERVAL秒毎に処理を実行する
        adTimer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL,
                                       repeats: true,
                                       block: { (timer) in
            guard let num = self.viewModel.selectAdImageNumber(),
                  let image = self.viewModel.adItems[num].image else {
                return
            }
            self.viewModel.displayAdImagesNumber = num // これから表示させる広告の配列番号を覚える
            self.adImageView.loadCacheImage(urlStr: image) // 広告画像の表示
        })
    }
    
    /// レイアウト初期設定
    private func layoutInitSetting() {
        
        // adImageView
        adImageView.isUserInteractionEnabled = true // タップ無効
        adImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedAdImageView(_:))))
        
        // webViewForLogin
        webViewForLogin.navigationDelegate = self
        
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
        
        // collectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // 1つのCell(xib)サイズを変更
        collectionView.collectionViewLayout = layout
        collectionView.register(R.nib.homeCollectionCell) // xibファイルを使うことを登録
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(gesture:)))
        collectionView.addGestureRecognizer(longTapGesture)
    }
    
    /// 通信初期設定
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
                    guard let num = self.viewModel.displayAdImagesNumber,
                          let image = self.viewModel.adItems[num].image else {
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
