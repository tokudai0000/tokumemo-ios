//
//  BaseViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/27.
//

import UIKit

class BaseViewController: UIViewController {
    
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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setActivityIndicator()
    }
    
    private func setActivityIndicator() {
        // ActivityIndicatorを作成＆中央に配置
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1)
        activityIndicator.hidesWhenStopped = true // クルクルをストップした時に非表示する
        self.view.addSubview(activityIndicator)
    }
    
    // ステータスバーを表示(true),非表示(false)
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    // MARK: - Public func
    
    private var toastView:UIView?
    private var toastShowFrame:CGRect = .zero
    private var toastHideFrame:CGRect = .zero
    private var toastInterval:TimeInterval = 3.0
    
    public var isToastShow : Bool {
        get {
            return toastView == nil ? false : true
        }
    }
    
    enum ToastType {
        case top
        case bottom
    }
    
    /// トースト表示
    ///
    /// - Parameters:
    ///   - message: メッセージ
    ///   - interval: 表示時間（秒）デフォルト3秒
    open func toast( message: String, type: ToastType = .bottom, interval:TimeInterval = 3.0 ) {
        guard self.toastView == nil else {
            return // 既に表示準備中
        }
        self.toastView = UIView()
        guard let toastView = self.toastView else { // アンラッピング
            return
        }
        
        toastInterval = interval
        
        switch type {
        case .top:
            toastShowFrame = CGRect(x: 15,
                                    y: 8,
                                    width: self.view.frame.width - 15 - 15,
                                    height: 46)
            
            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
                                    y: 0 - toastShowFrame.height * 2,  // 上に隠す
                                    width: toastShowFrame.width,
                                    height: toastShowFrame.height)
            
        case .bottom:
            toastShowFrame = CGRect(x: 15,
                                    y: self.view.frame.height - 100,
                                    width: self.view.frame.width - 15 - 15,
                                    height: 46)
            
            toastHideFrame = CGRect(x: toastShowFrame.origin.x,
                                    y: self.view.frame.height - toastShowFrame.height * 2,  // 上に隠す
                                    width: toastShowFrame.width,
                                    height: toastShowFrame.height)
            
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
        // 幅を制約して高さを求める
        label.frame.size = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
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
    
    //MARK:- Override
    // キーボード非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

