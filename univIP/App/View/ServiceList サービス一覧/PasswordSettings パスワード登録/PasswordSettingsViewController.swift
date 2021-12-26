//
//  PassWordSettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class PasswordSettingsViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var cAccountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var cAccountTextSizeLabel: UILabel!
    @IBOutlet weak var passwordTextSizeLabel: UILabel!
    
    @IBOutlet weak var cAccountMessageLabel: UILabel!
    @IBOutlet weak var passwordMessageLabel: UILabel!
    
    @IBOutlet weak var cAccountUnderLine: UIView!
    @IBOutlet weak var passwordUnderLine: UIView!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordViewButton: UIButton!
    
    public var delegate : MainViewController?
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cAccountTextFieldCursorSetup(type: .normal)
        passwordTextFieldCursorSetup(type: .normal)
        
        cAccountTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        
        cAccountTextField.delegate = self
        passwordTextField.delegate = self
        
        cAccountTextField.text = dataManager.cAccount
        passwordTextField.text = dataManager.password
        
        cAccountTextSizeLabel.text = "\(dataManager.cAccount.count)/10"
        passwordTextSizeLabel.text = "\(dataManager.password.count)/100"
        
        cAccountMessageLabel.textColor = .red
        passwordMessageLabel.textColor = .red
        
        passwordTextField.isSecureTextEntry = true
        registerButton.layer.cornerRadius = 5.0
    }
    
    
    // MARK: - IBAction
    @IBAction func registrationButton(_ sender: Any) {
        guard let cAccountText = cAccountTextField.text else {
            cAccountMessageLabel.text = "空欄です"
            cAccountTextFieldCursorSetup(type: .error)
            return
        }
        guard let passwordText = passwordTextField.text else {
            passwordMessageLabel.text = "空欄です"
            passwordTextFieldCursorSetup(type: .error)
            return
        }
        
        if cAccountText.prefix(1) != "c" {
            cAccountMessageLabel.text = "cアカウントを入力してください"
            cAccountTextFieldCursorSetup(type: .error)
            return
        }
        
        dataManager.cAccount = cAccountText
        dataManager.password = passwordText
        
        cAccountTextFieldCursorSetup(type: .normal)
        passwordTextFieldCursorSetup(type: .normal)
        
        if let delegate = delegate {
            guard let url = URL(string: Url.manabaPC.string()) else {fatalError()}
            delegate.webView.load(URLRequest(url: url))
            dismiss(animated: true, completion: nil)
        }
    }
    
    /// パスワードのシークレットモード
    @IBAction func passwordViewChangeButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
        if passwordTextField.isSecureTextEntry {
            // シークレットモード
            passwordViewButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordViewButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Private
    
    enum cursorType {
        case normal
        case forcas
        case error
    }
    private func cAccountTextFieldCursorSetup(type: cursorType) {
        switch type {
            
        case .normal:
            cAccountUnderLine.backgroundColor = .lightGray
            
        case .forcas:
            // カーソルの色
            cAccountTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
            cAccountUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
            
        case .error:
            cAccountTextField.tintColor = .red
            cAccountUnderLine.backgroundColor = .red
        }
    }
    
    private func passwordTextFieldCursorSetup(type: cursorType) {
        switch type {
            
        case .normal:
            passwordUnderLine.backgroundColor = .lightGray
            
        case .forcas:
            passwordTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
            passwordUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
            
        case .error:
            passwordTextField.tintColor = .red
            passwordUnderLine.backgroundColor = .red
        }
    }
}


// MARK: - UITextFieldDelegate
extension PasswordSettingsViewController: UITextFieldDelegate {
    
    // キーボードが現れる直前
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // キーボードで隠されたくない範囲（注意！super.viewからの絶対座標で渡すこと）
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
    
    
    enum TextFieldTag: Int {
        case cAccount = 0
        case password = 1
    }
    // textField編集前
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldTag = TextFieldTag(rawValue: textField.tag)
        
        switch textFieldTag {
        case .cAccount:
            cAccountTextFieldCursorSetup(type: .forcas)
            
        case .password:
            passwordTextFieldCursorSetup(type: .forcas)
            
        case .none:
            AKLog(level: .FATAL, message: "TextFieldTagが不正")
            fatalError()
        }
    }
    // textField編集後
    func textFieldDidEndEditing(_ textField: UITextField) {
        cAccountTextFieldCursorSetup(type: .normal)
        passwordTextFieldCursorSetup(type: .normal)
    }
    
    // text内容が変更されるたびに
    func textFieldDidChangeSelection(_ textField: UITextField) {
        cAccountTextSizeLabel.text = "\(cAccountTextField.text?.count ?? 0)/10"
        passwordTextSizeLabel.text = "\(passwordTextField.text?.count ?? 0)/100"
    }
    
}


// MARK: - Notification
extension PasswordSettingsViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // キーボードの通知セット
        let notification = NotificationCenter.default
        // キーボードが現れる直前
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        // キーボードが隠れる直前
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
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
