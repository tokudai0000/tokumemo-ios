//
//  BaseViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/27.
//

import UIKit

class BaseViewController: UIViewController {
    public var mainViewModel: MainViewModel!
    // MARK: - Public property
    
    // キーボードで隠されたくない範囲（UITextField.frameなどをセットする）
    public var keyboardSafeArea: CGRect? = nil
    /** UITextFieldDelegateにて下記コードを組み込んでUITextField.frameを知らせる。
            /// 入力可能になる直前
            func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
                // BaseViewControllerへキーボードで隠されたくない範囲を伝える（注意！super.viewからの絶対座標で渡すこと）
                var frame = textField.frame
                // super.viewからの絶対座標に変換する
                if var pv = textField.superview {
                    while pv != super.view {
                        if let gv = pv.superview {
                            frame = pv.convert(frame, to: gv)
                            pv = gv
                        }else{
                            break
                        }
                    }
                }
                super.keyboardSafeArea = frame // super.viewからの絶対座標
                return true //true=キーボードを表示する
            }
    **/

    var activityIndicator: UIActivityIndicatorView!
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // ダークモード回避
        self.overrideUserInterfaceStyle = .light
//        self.overrideUserInterfaceStyle = .dark
        
        // ActivityIndicatorを作成＆中央に配置
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1)
        activityIndicator.hidesWhenStopped = true // クルクルをストップした時に非表示する
        self.view.addSubview(activityIndicator)
    }

    
    /// 画面が現れる直前
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 通知セット
        let notification = NotificationCenter.default
        // キーボードが現れる直前
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        // キーボードが隠れる直前
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // ステータスバーを表示(true),非表示(false)
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    /// キーボードが現れる直前、画面全体を上げる
    @objc func keyboardWillShow(notification: Notification?) {
        guard keyboardSafeArea != nil,
            notification != nil else {
            return
        }
        guard let userInfo = notification!.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        // キーボドに隠れるか判定する
//        print("self.view.frame: \(self.view.frame)")
        let safeAreaTop:CGFloat = 5.0
//        print("keyboardSize.height: \(keyboardSize.height)")
//        print("keyboardSafeArea!.maxY: \(keyboardSafeArea!.maxY)")
        let hide = (self.view.frame.height - safeAreaTop - keyboardSize.height) - keyboardSafeArea!.maxY
        if hide < 0.0 {
            // キーボドに隠れる。隠れる分(hide)だけ上げる
            if UIApplication.shared.applicationState == .background {
                // フォアグランドに戻ったとき画面が上がらない不具合対応
                // DispatchQueue.mainThread では改善しなかった。（メイン判定に問題があるのかも知れない）
                DispatchQueue.main.async {
                    UIView.animate(withDuration: duration + 0.2, animations: { () in
                        let transform = CGAffineTransform(translationX: 0, y: hide - safeAreaTop)
                        self.view.transform = transform
                    })
                }
            } else {
                UIView.animate(withDuration: duration + 0.2, animations: { () in
                    let transform = CGAffineTransform(translationX: 0, y: hide - safeAreaTop)
                    self.view.transform = transform
                })
            }
        }
    }
    
    /// キーボードが隠れる直前、画面全体を元に戻す
    @objc func keyboardWillHide(notification: Notification?) {
        guard keyboardSafeArea != nil,
            notification != nil else {
                return
        }
        guard let userInfo = notification!.userInfo as? [String: Any] else {
            return
        }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        UIView.animate(withDuration: duration + 0.2, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
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
    open func toast( message: String, type: String = "bottom", interval:TimeInterval = 3.0 ) {
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
    
    open func textFieldEmputyConfirmation(text : String) -> Bool{
        switch text {
        case "":
            return true
        case " ":
            return true
        case "  ":
            return true
        case "   ":
            return true
        case "　":
            return true
        case "　　":
            return true
        case "　　　":
            return true
        case " 　":
            return true
        case "　 ":
            return true
        default:
            return false
        }
    }
    //MARK:- Override
    // キーボード非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

