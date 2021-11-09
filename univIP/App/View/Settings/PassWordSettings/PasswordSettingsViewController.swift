//
//  PassWordSettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class PasswordSettingsViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var cAccountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cAccountTextSizeLabel: UILabel!
    @IBOutlet weak var passwordTextSizeLabel: UILabel!
    
    public var delegate : MainViewController?
    
    private let dataManager = DataManager.singleton
    private let model = Model()
    private let webViewModel = WebViewModel()
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
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
    
    
    //MARK:- IBAction
    @IBAction func registrationButton(_ sender: Any) {
        
        if let cAccountText = cAccountTextField.text{
            DataManager.singleton.cAccount = cAccountText
        }
        if let passWordText = passwordTextField.text{
            DataManager.singleton.password = passWordText
        }
        
        delegate?.webView.load(webViewModel.url(.login)! as URLRequest)
    }
    
    @IBAction func passwordViewChangeButton(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
    }
    
    @IBAction func dissmissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        cAccountTextSizeLabel.text = "\(cAccountTextField.text?.count)/10"
        passwordTextSizeLabel.text = "\(passwordTextField.text?.count)/100"
        return true
    }
    
    
    // MARK:- Public func
    public func restoreView(){
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.viewTop.layer.position.x -= 250
        },
            completion: { bool in
        })
    }
    
    
    private func setup() {
        
        passwordTextField.isSecureTextEntry = true
        registerButton.layer.cornerRadius = 5.0
        cAccountTextField.setUnderLine()
        passwordTextField.setUnderLine()
        
        cAccountTextField.delegate = self
        passwordTextField.delegate = self
        

        cAccountTextField.text = dataManager.cAccount
        passwordTextField.text = dataManager.password
        cAccountTextSizeLabel.text = "\(cAccountTextField.text?.count ?? 0)/10"
        passwordTextSizeLabel.text = "\(passwordTextField.text?.count ?? 0)/100"
        
    }
    
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
        
        let safeAreaTop:CGFloat = 5.0
        
        let hide = (self.view.frame.height - safeAreaTop - keyboardSize.height) - keyboardSafeArea!.maxY
        
        if hide < 0.0 {
            // キーボドに隠れる。隠れる分(hide)だけ上げる
            if UIApplication.shared.applicationState == .background {
                // フォアグランドに戻ったとき画面が上がらない不具合対応
                // DispatchQueue.mainThread では改善しなかった。（メイン判定に問題があるのかも知れない）
                DispatchQueue.main.async {
                    UIView.animate(withDuration: duration + 0.2, animations: { () in
                        let transform = CGAffineTransform(translationX: 0, y: hide - safeAreaTop)
                        self.registerButton.transform = transform
                    })
                }
            } else {
                UIView.animate(withDuration: duration + 0.2, animations: { () in
                    let transform = CGAffineTransform(translationX: 0, y: hide - safeAreaTop)
                    self.registerButton.transform = transform
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
            self.registerButton.transform = CGAffineTransform.identity
        })
    }
}

// MARK:- TextField
extension PasswordSettingsViewController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // BaseViewControllerへキーボードで隠されたくない範囲を伝える（注意！super.viewからの絶対座標で渡すこと）
        var frame = registerButton.frame
        // super.viewからの絶対座標に変換する
        if var pv = registerButton.superview {
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
}

extension UITextField {
    func setUnderLine() {
        // 枠線を非表示にする
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        // 枠線の色
        underline.backgroundColor = .white
        addSubview(underline)
        // 枠線を最前面に
        bringSubviewToFront(underline)
    }
}
