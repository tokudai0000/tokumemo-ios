//
//  PassWordSettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class PasswordViewController: UIViewController {
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initSetup()
    }
    
    // MARK: - IBAction
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// パスワードの表示、非表示モード
    @IBAction func passwordViewChangeButton(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
        if passwordTextField.isSecureTextEntry {
            // 非表示モード
            passwordViewButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            // 表示モード
            passwordViewButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    @IBAction func registrationButton(_ sender: Any) {
        // textField.textはnilにはならずOptional("")となる(objective-c仕様の名残)
        guard let cAccountText = cAccountTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        
        if cAccountText.isEmpty {
            cAccountMessageLabel.text = "空欄です"
            textFieldCursorSetup(fieldType: .cAccount, cursorType: .error)
            return
        }
        
        if passwordText.isEmpty {
            passwordMessageLabel.text = "空欄です"
            textFieldCursorSetup(fieldType: .password, cursorType: .error)
            return
        }
        
        if cAccountText.prefix(1) != "c" ||
            cAccountText.count > 10 {
            cAccountMessageLabel.text = "cアカウント例(c100100100)"
            textFieldCursorSetup(fieldType: .cAccount, cursorType: .error)
            return
        }
        // KeyChianに保存する
        dataManager.cAccount = cAccountText
        dataManager.password = passwordText
        
        if let delegate = delegate {
            delegate.webView.load(Url.universityLogin.urlRequest())
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private
    /// PasswordSettingsViewControllerの初期セットアップ
    private func initSetup() {
        do { // 1. cアカウント
            textFieldCursorSetup(fieldType: .cAccount, cursorType: .normal)
            cAccountTextField.borderStyle = .none
            cAccountTextField.delegate = self
            cAccountTextField.text = dataManager.cAccount
            cAccountTextSizeLabel.text = "\(dataManager.cAccount.count)/10"
            cAccountMessageLabel.textColor = .red
        }
        
        do { // 2. パスワード
            textFieldCursorSetup(fieldType: .password, cursorType: .normal)
            passwordTextField.borderStyle = .none
            passwordTextField.delegate = self
            passwordTextField.text = dataManager.password
            passwordTextSizeLabel.text = "\(dataManager.password.count)/100"
            passwordMessageLabel.textColor = .red
            passwordTextField.isSecureTextEntry = true
        }
        // 登録ボタンの角を丸める
        registerButton.layer.cornerRadius = 5.0
        
        // キーボードの通知セット
        let notification = NotificationCenter.default
        // キーボードが現れる直前呼び出す
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        // キーボードが隠れる直前呼び出す
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// TextFieldの種類
    enum FieldType: Int {
        case cAccount = 0 // 科目名
        case password = 1 // 教員名
    }
    /// カーソルの表示種類
    enum CursorType {
        case normal // 非選択状態
        case focus // 選択状態
        case error // 入力エラー状態
    }
    /// TextFieldの状態を変化させる
    /// - Parameters:
    ///   - fieldType: 変化させたいTextFieldの種類
    ///   - cursorType: 変化させたい状態
    private func textFieldCursorSetup(fieldType: FieldType, cursorType: CursorType) {
        switch fieldType {
            case .cAccount:
                switch cursorType {
                    case .normal:
                        // 非選択状態
                        cAccountUnderLine.backgroundColor = .lightGray
                        
                    case .focus:
                        // 選択状態
                        // カーソルの色
                        cAccountTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                        cAccountUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                        
                    case .error:
                        cAccountTextField.tintColor = .red
                        cAccountUnderLine.backgroundColor = .red
                }
            case .password:
                switch cursorType {
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
}

// MARK: - UITextFieldDelegate
extension PasswordViewController: UITextFieldDelegate {
    // textField編集前
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldTag = FieldType(rawValue: textField.tag)
        
        switch textFieldTag {
        case .cAccount:
                textFieldCursorSetup(fieldType: .cAccount, cursorType: .focus)
            
        case .password:
                textFieldCursorSetup(fieldType: .password, cursorType: .focus)
            
        case .none:
            AKLog(level: .FATAL, message: "TextFieldTagが不正")
            fatalError()
        }
    }
    /// textField編集後
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldCursorSetup(fieldType: .cAccount, cursorType: .normal)
        textFieldCursorSetup(fieldType: .password, cursorType: .normal)
    }
    /// text内容が変更されるたびに
    func textFieldDidChangeSelection(_ textField: UITextField) {
        cAccountTextSizeLabel.text = "\(cAccountTextField.text?.count ?? 0)/10"
        passwordTextSizeLabel.text = "\(passwordTextField.text?.count ?? 0)/100"
    }
}

// キーボード関連
extension PasswordViewController {
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
