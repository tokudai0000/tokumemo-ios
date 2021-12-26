//
//  SearchViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class SyllabusViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    
    @IBOutlet weak var subjectTextSizeLabel: UILabel!
    @IBOutlet weak var teacherTextSizeLabel: UILabel!
    
    @IBOutlet weak var subjectUnderLine: UIView!
    @IBOutlet weak var teacherUnderLine: UIView!
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    public var delegate : MainViewController?
    
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
        teacherTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
        
        subjectTextField.borderStyle = .none
        teacherTextField.borderStyle = .none
        
        subjectTextField.delegate = self
        teacherTextField.delegate = self
        
        subjectTextSizeLabel.text = "\(subjectTextField.text?.count ?? 0)/20"
        teacherTextSizeLabel.text = "\(teacherTextField.text?.count ?? 0)/20"
        
        searchButton.layer.cornerRadius = 5.0
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
    @IBAction func searchButton(_ sender: Any) {
        
        guard let delegate = self.delegate else {
            AKLog(level: .FATAL, message: "[delegateエラー]: MainViewControllerから delegate=self を渡されていない")
            fatalError()
        }
        
        let subjectText = subjectTextField.text ?? ""
        let teacherText = teacherTextField.text ?? ""
        
        delegate.refreshSyllabus(subjectName: subjectText,
                                 teacherName: teacherText)
        
        dismiss(animated: true, completion: nil)
        
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
    // 科目名フィールド
    private func subjectTextFieldCursorSetup(type: cursorType) {
        switch type {
            case .normal:
                // 非選択状態
                subjectUnderLine.backgroundColor = .lightGray
                
            case .forcas:
                // 選択状態
                // カーソルの色
                subjectTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                subjectUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                
            case .error:
                subjectTextField.tintColor = .red
                subjectUnderLine.backgroundColor = .red
        }
    }
    // 教員名フィールド
    private func teacherTextFieldCursorSetup(type: cursorType) {
        switch type {
            case .normal:
                // 非選択状態
                teacherUnderLine.backgroundColor = .lightGray
                
            case .forcas:
                // 選択状態
                teacherTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                teacherUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                
            case .error:
                teacherTextField.tintColor = .red
                teacherUnderLine.backgroundColor = .red
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension SyllabusViewController: UITextFieldDelegate {
    
    enum TextFieldTag: Int {
        case subject = 0
        case teacher = 1
    }
    // textField編集前
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldTag = TextFieldTag(rawValue: textField.tag)
        
        switch textFieldTag {
            case .subject:
                subjectTextFieldCursorSetup(type: .forcas)
                
            case .teacher:
                teacherTextFieldCursorSetup(type: .forcas)
                
            case .none:
                AKLog(level: .FATAL, message: "TextFieldTagが不正")
                fatalError()
        }
    }
    
    // textField編集後
    func textFieldDidEndEditing(_ textField: UITextField) {
        subjectTextFieldCursorSetup(type: .normal)
        teacherTextFieldCursorSetup(type: .normal)
    }
    
    // text内容が変更されるたびに
    func textFieldDidChangeSelection(_ textField: UITextField) {
        subjectTextSizeLabel.text = "\(subjectTextField.text?.count ?? 1)/20"
        teacherTextSizeLabel.text = "\(teacherTextField.text?.count ?? 1)/20"
    }

}


// キーボード関連
extension SyllabusViewController {
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
            self.searchButton.transform = transform
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
            self.searchButton.transform = CGAffineTransform.identity
        })
    }
    
    // キーボードを非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
