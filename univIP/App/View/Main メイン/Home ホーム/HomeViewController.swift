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
    @IBOutlet weak var prContainerView: UIView!
    @IBOutlet weak var prImageView: UIImageView!
    @IBOutlet weak var weatherView: UIStackView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var webViewForLogin: WKWebView!
    
    private let viewModel = HomeViewModel()
    
    // 共通データ・マネージャ
    private let dataManager = DataManager.singleton
    
    //
    private var adTimer = Timer()
    
    // トースト表示
    private var toastView: UIView?
    
    private var toastShowFrame: CGRect = .zero
    
    private var toastHideFrame: CGRect = .zero
    
    private var toastInterval: TimeInterval = 3.0
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupDelegate()
        setupRecognizer()
        setupConstraints()
        setupViewStateUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewOnAppear()
        setupPRTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adTimer.invalidate()
    }
    
    // MARK: - IBAction
    
    @IBAction func contactUsButton(_ sender: Any) {
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = Url.contactUs.string()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func tappedAdImageView(_ sender: UITapGestureRecognizer) {
        guard let num = viewModel.displayPRImagesNumber,
              let image = viewModel.prItems[num].imageURL,
              let txt = viewModel.prItems[num].introduction,
              let url = viewModel.prItems[num].tappedURL else {
            return
        }
        let vc = R.storyboard.pR.prViewController()!
        vc.imageUrlStr = image
        vc.introductionText = txt
        vc.urlStr = url
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Methods [Private]
    
    private func setupDefaults() {
        prImageView.isUserInteractionEnabled = true
        collectionView.register(R.nib.homeCollectionCell)
        webViewForLogin.isHidden = true
        #if STUB
        webViewForLogin.isHidden = false
        #endif
    }
    
    private func setupDelegate() {
        webViewForLogin.navigationDelegate = self
    }
    
    private func setupRecognizer() {
        prImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedAdImageView(_:))))
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTap(gesture:))))
    }
    
    private func setupConstraints() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
    }
    
    private func setupViewOnAppear() {
        collectionView.reloadData()
        dataManager.canExecuteJavascript = true
        webViewForLogin.load(Url.universityTransitionLogin.urlRequest())
        viewModel.getPRItems()
    }
    
    private func setupPRTimer() {
        var TIME_INTERVAL = 5.0
        #if STUB
        TIME_INTERVAL = 2.0
        #endif
        adTimer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL,
                                       repeats: true,
                                       block: { (timer) in
            self.displayPRImage()
        })
    }
    
    // ViewModelが変化したことの通知を受けて画面を更新する
    private func setupViewStateUpdate() {
        self.viewModel.state = { [weak self] (state) in
            guard let self = self else { fatalError() }
            DispatchQueue.main.async {
                switch state {
                case .busy:
                    break
                case .ready:
                    self.displayPRImage()
                    break
                case .error:
                    break
                }
            }
        }
    }
    
    private func displayPRImage() {
        guard let num = self.viewModel.selectPRImageNumber(),
              let image = self.viewModel.prItems[num].imageURL else {
            return
        }
        self.viewModel.displayPRImagesNumber = num
        self.prImageView.loadCacheImage(urlStr: image)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menuLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)!
        let collectionList = viewModel.menuLists[indexPath.row]
        let title = collectionList.title
        let icon = collectionList.image
        cell.setupCell(title: title, image: icon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = viewModel.menuLists[indexPath.row]
        switch cell.id {
            case .syllabus:
                let vc = R.storyboard.input.inputViewController()!
                vc.type = .syllabus
                present(vc, animated: true)
            case .currentTermPerformance: // 今年の成績
                let vc = R.storyboard.web.webViewController()!
                vc.loadUrlString = viewModel.createCurrentTermPerformanceUrl()
                present(vc, animated: true, completion: nil)
            case .libraryCalendar:
                libraryAlart()
                return
            default:
                break
        }
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = cell.url
        present(vc, animated: true, completion: nil)
    }
        
    // 長押しタップ時に並び替え
    @objc func longTap(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var displayLists = viewModel.menuLists
        let item = displayLists.remove(at: sourceIndexPath.row)
        displayLists.insert(item, at: destinationIndexPath.row)
        var hiddonLists:[MenuListItem] = []
        for list in dataManager.menuLists {
            if list.isHiddon {
                hiddonLists.append(list)
            }
        }
        dataManager.menuLists = displayLists + hiddonLists
    }
    
    /// 図書館では常三島と蔵本の2つのカレンダーを選択させるためにアラートを表示
    /// 常三島と蔵本を選択させるpopup(**Alert**)を表示 **推奨されたAlertの使い方ではない為、修正すべき**
    private func libraryAlart() {
        var alert:UIAlertController!
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
        alert.addAction(alertAction)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion:nil)
    }
}

extension HomeViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url == nil {
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
    }
    
    // 徳島大学　統合認証システムサイト(ログインサイト)に自動ログインを行う。JavaScriptInjection
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = self.webViewForLogin.url! // fatalErro
        if viewModel.canExecuteJS(url.absoluteString) {
            webView.evaluateJavaScript("document.getElementById('username').value= '\(dataManager.cAccount)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementById('password').value= '\(dataManager.password)'", completionHandler:  nil)
            webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
        }
        AKLog(level: .DEBUG, message: url.absoluteString)
    }
}

extension HomeViewController {
    
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
}
