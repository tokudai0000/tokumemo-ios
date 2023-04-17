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
    
    private let viewModel = HomeViewModel()
    private let dataManager = DataManager.singleton
    private var adTimer = Timer()
    
    private var toastView:UIView?
    private var toastShowFrame:CGRect = .zero
    private var toastHideFrame:CGRect = .zero
    private var toastInterval:TimeInterval = 3.0
    
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adImageView
        prImageView.isUserInteractionEnabled = true // タップ無効
        prImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedAdImageView(_:))))
        
        // collectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // 1つのCell(xib)サイズを変更
        collectionView.collectionViewLayout = layout
        collectionView.register(R.nib.homeCollectionCell) // xibファイルを使うことを登録
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(gesture:)))
        collectionView.addGestureRecognizer(longTapGesture)
        
        
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
                    
                case .prBusy:
                    break
                    
                case .prReady:
                    guard let num = self.viewModel.displayPRImagesNumber,
                          let image = self.viewModel.prItems[num].imageURL else {
                        return
                    }
                    // 広告画像の表示
                    self.prImageView.loadCacheImage(urlStr: image)
                    break
                    
                case .prError:
                    break
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                        
        collectionView.reloadData() // カスタマイズ機能で並び替えを反映するため
        
        viewModel.getPRItems()
        viewModel.getWether()
        
        var TIME_INTERVAL = 5.0 // 広告を表示させる秒数
        
        #if STUB
        TIME_INTERVAL = 2.0
        #endif
        
        // TIME_INTERVAL秒毎に処理を実行する
        adTimer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL,
                                       repeats: true,
                                       block: { (timer) in
            guard let num = self.viewModel.selectPRImageNumber(),
                  let image = self.viewModel.prItems[num].imageURL else {
                return
            }
            self.viewModel.displayPRImagesNumber = num // これから表示させる広告の配列番号を覚える
            self.prImageView.loadCacheImage(urlStr: image) // 広告画像の表示
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adTimer.invalidate() // タイマー停止
    }
    
    // weatherViewがタップされた時用
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
}

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// セル数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menuLists.count
    }
    
    /// セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)! // fatalError
        
        let collectionList = viewModel.menuLists[indexPath.row]//viewModel.collectionLists[indexPath.row]
        
        let title = collectionList.title
        var icon = collectionList.image // fatalError
        
        // ログインが完了していないユーザーには鍵アイコンを表示(上書きする)
        if dataManager.loginState.completed == false, collectionList.isLockIconExists {
            icon = R.image.menuIcon.lock.name
        }
        
        cell.setupCell(title: title, image: icon)
        return cell
    }
    
    /// セルがタップされた時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップされたセルの内容を取得
        let cell = viewModel.menuLists[indexPath.row]
        
        Analytics.logEvent("Cell[\(cell.id)]", parameters: nil) // Analytics
        
        // パスワード未登録、ロック画像ありのアイコン(ログインが必要)を押した場合
        if viewModel.hasRegisteredPassword() == false , cell.isLockIconExists {
            toast(message: "Settings -> パスワード設定から自動ログイン機能をONにしましょう")
            return
        }
        
        // 今年の成績だけ変化する為、保持する
        var loadUrlString = cell.url
        
        switch cell.id {
            case .syllabus:
                let vc = R.storyboard.input.inputViewController()!
                vc.type = .syllabus
                present(vc, animated: true)
                
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

// トースト表示について
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
