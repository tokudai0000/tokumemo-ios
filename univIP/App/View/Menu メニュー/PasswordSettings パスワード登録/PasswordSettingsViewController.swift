//
//  PassWordSettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class PasswordSettingsViewController: UIViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // キーボードの通知セット
        let notification = NotificationCenter.default
        // キーボードが現れる直前呼び出す
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        // キーボードが隠れる直前呼び出す
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        if cAccountText.prefix(1) != "c" ||
            cAccountText.count > 10 {
            cAccountMessageLabel.text = "cアカウント例(c100100100)"
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
        case focus
        case error
    }
    private func cAccountTextFieldCursorSetup(type: cursorType) {
        switch type {
            
        case .normal:
            cAccountUnderLine.backgroundColor = .lightGray
            
        case .focus:
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
            
        case .focus:
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
    
    enum TextFieldTag: Int {
        case cAccount = 0
        case password = 1
    }
    // textField編集前
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldTag = TextFieldTag(rawValue: textField.tag)
        
        switch textFieldTag {
        case .cAccount:
            cAccountTextFieldCursorSetup(type: .focus)
            
        case .password:
            passwordTextFieldCursorSetup(type: .focus)
            
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


// キーボード関連
extension PasswordSettingsViewController {
    // キーボードが現れる直前に呼ばれる
    @objc func keyboardWillShow(notification: Notification?) {
        // UIKeyboardWillShowNotification を取得
        guard let notification = notification else {
            AKLog(level: .ERROR, message: "[notification取得エラー]")
            return
        }
        // キーボード関連の情報
        guard let userInfo = notification.userInfo as? [String: Any] else {
            AKLog(level: .ERROR, message: "[userInfo取得エラー]")
            return
        }
        // キーボードの表示範囲
        // NSRect{{x, y}, {wide, hight}}
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            AKLog(level: .ERROR, message: "[keyboardInfo取得エラー]")
            return
        }
        // キーボード表示アニメーション時間
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            AKLog(level: .ERROR, message: "[duration取得エラー]")
            return
        }
        
        // キーボードで隠れた高さ
        let hideY = -keyboardInfo.cgRectValue.size.height
        
        UIView.animate(withDuration: duration + 0.2, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: hideY)
            self.registerButton.transform = transform
        })
    }
    
    // キーボードが隠れる直前呼ばれる
    @objc func keyboardWillHide(notification: Notification?) {
        // 画面全体を元に戻す
        // UIKeyboardWillShowNotification を取得
        guard let notification = notification else {
            AKLog(level: .ERROR, message: "[notification取得エラー]")
            return
        }
        // キーボード関連の情報
        guard let userInfo = notification.userInfo as? [String: Any] else {
            AKLog(level: .ERROR, message: "[userInfo取得エラー]")
            return
        }
        // キーボード表示アニメーション時間
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            AKLog(level: .ERROR, message: "[duration取得エラー]")
            return
        }
        
        UIView.animate(withDuration: duration + 0.2, animations: { () in
            self.registerButton.transform = CGAffineTransform.identity
        })
    }
    
    // キーボードを非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
