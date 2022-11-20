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
    @IBOutlet weak var studentNumberTextField: UITextField!
    @IBOutlet weak var studentNumberTextSizeLabel: UILabel!
    @IBOutlet weak var studentNumberMessageLabel: UILabel!
    @IBOutlet weak var studentNumberUnderLine: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextSizeLabel: UILabel!
    @IBOutlet weak var passwordMessageLabel: UILabel!
    @IBOutlet weak var passwordUnderLine: UIView!
    @IBOutlet weak var passwordViewButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initSetup()
    }
    
    // MARK: - IBAction
    
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

    @IBAction func resetButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "アラート表示",
                                                         message: "学生番号とパスワードの情報をこのスマホから消去しますか？",
                                                         preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK",
                                                         style: UIAlertAction.Style.default,
                                                         handler:{ (action: UIAlertAction!) -> Void in
            self.dataManager.studentNumber = ""
            self.dataManager.password = ""
            self.initSetup()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル",
                                                        style: UIAlertAction.Style.cancel,
                                                        handler:{ (action: UIAlertAction!) -> Void in })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registrationButton(_ sender: Any) {
        // textField.textはnilにはならずOptional("")となる(objective-c仕様の名残)
        guard let studentNumberText = studentNumberTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        
        // 学生番号が空欄の場合
        if studentNumberText.isEmpty {
            studentNumberMessageLabel.text = "空欄です"
            textFieldCursorSetup(fieldType: .studentNumber, cursorType: .error)
            return
        }
        
        // パスワードが空欄の場合
        if passwordText.isEmpty {
            passwordMessageLabel.text = "空欄です"
            textFieldCursorSetup(fieldType: .password, cursorType: .error)
            return
        }
        
        // 学生番号が10桁以上の場合
        if studentNumberText.prefix(1) == "c" {
            studentNumberMessageLabel.text = "cアカウントではなく、学生番号です"
            textFieldCursorSetup(fieldType: .studentNumber, cursorType: .error)
            return
        }
        
        // 学生番号が10桁以上の場合
        if 10 < studentNumberText.count {
            studentNumberMessageLabel.text = "10桁の学生番号を入れてください"
            textFieldCursorSetup(fieldType: .studentNumber, cursorType: .error)
            return
        }
        
        // KeyChianに保存する
        dataManager.studentNumber = studentNumberText
        dataManager.password = passwordText
        
        // 失敗した後、成功した場合にはエラー表示を初期化する
        initSetup()
        
        alert(title: "♪ 登録完了 ♪",
              message: "以降、アプリを開くたびに自動ログインの機能が使用できる様になりました。")
    }
    
    /// パスワード入力を推奨するポップアップを表示させる。
    public func makeReminderPassword() {
        var alert:UIAlertController!
        alert = UIAlertController(title: "", message: "パスワードの入力を行うと、\n自動でログインしてくれるようになります。", preferredStyle: UIAlertController.Style.alert)
        
        let main = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: { action in

            })
        alert.addAction(main)

        present(alert, animated: true, completion:nil)
        
    }
    
    // MARK: - Private
    /// PasswordSettingsViewControllerの初期セットアップ
    private func initSetup() {
        do { // 1. cアカウント
            textFieldCursorSetup(fieldType: .studentNumber, cursorType: .normal)
            studentNumberTextField.borderStyle = .none
            studentNumberTextField.delegate = self
            studentNumberTextField.text = dataManager.studentNumber
            studentNumberTextSizeLabel.text = "\(dataManager.studentNumber.count)/10"
            studentNumberMessageLabel.textColor = .red
            studentNumberMessageLabel.text = ""
        }
        
        do { // 2. パスワード
            textFieldCursorSetup(fieldType: .password, cursorType: .normal)
            passwordTextField.borderStyle = .none
            passwordTextField.delegate = self
            passwordTextField.text = dataManager.password
            passwordTextSizeLabel.text = "\(dataManager.password.count)/100"
            passwordMessageLabel.textColor = .red
            passwordMessageLabel.text = ""
            passwordTextField.isSecureTextEntry = true
        }
        
        // 学生番号とパスワードのリセット
        resetButton.layer.cornerRadius = 25.0
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
    
    private var alertController: UIAlertController!
    private func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    /// TextFieldの種類
    enum FieldType: Int {
        case studentNumber = 0 // 科目名
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
            case .studentNumber:
                switch cursorType {
                    case .normal:
                        // 非選択状態
                        studentNumberUnderLine.backgroundColor = .lightGray
                        
                    case .focus:
                        // 選択状態
                        // カーソルの色
                        studentNumberTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                        studentNumberUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                        
                    case .error:
                        studentNumberTextField.tintColor = .red
                        studentNumberUnderLine.backgroundColor = .red
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
        case .studentNumber:
                textFieldCursorSetup(fieldType: .studentNumber, cursorType: .focus)
            
        case .password:
                textFieldCursorSetup(fieldType: .password, cursorType: .focus)
            
        case .none:
            AKLog(level: .FATAL, message: "TextFieldTagが不正")
            fatalError()
        }
    }
    /// textField編集後
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldCursorSetup(fieldType: .studentNumber, cursorType: .normal)
        textFieldCursorSetup(fieldType: .password, cursorType: .normal)
    }
    /// text内容が変更されるたびに
    func textFieldDidChangeSelection(_ textField: UITextField) {
        studentNumberTextSizeLabel.text = "\(studentNumberTextField.text?.count ?? 0)/10"
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
