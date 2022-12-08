//
//  FavoriteViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/02/16.
//

import UIKit
import Firebase

class FavoriteViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var urlUnderLine: UIView!
    @IBOutlet weak var urlMessageLabel: UILabel!
    @IBOutlet weak var urlTextSizeLabel: UILabel!
    
    @IBOutlet weak var favoriteTextField: UITextField!
    @IBOutlet weak var favoriteUnderLine: UIView!
    @IBOutlet weak var favoriteMessageLabel: UILabel!
    @IBOutlet weak var favoriteTextSizeLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    public var urlString: String?
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextFieldCursorSetup(type: .normal)
        favoriteNameTextFieldCursorSetup(type: .normal)
        
        urlTextField.borderStyle = .none
        favoriteTextField.borderStyle = .none
        
        urlTextField.delegate = self
        favoriteTextField.delegate = self
        
        urlTextSizeLabel.text = "0/100"
        favoriteTextSizeLabel.text = "0/10"
        
        urlMessageLabel.textColor = .red
        favoriteMessageLabel.textColor = .red
        
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
    @IBAction func registerButton(_ sender: Any) {
        // textField.textはnilにはならずOptional("")となる(objective-c仕様の名残)
        guard let urlText = favoriteTextField.text else { return }
        guard let favoriteText = favoriteTextField.text else { return }
        
        let urlString = urlTextField.text
        
        if urlText.isEmpty {
            urlMessageLabel.text = "空欄です"
            urlTextFieldCursorSetup(type: .error)
            return
        }
        
        if favoriteText.isEmpty {
            favoriteMessageLabel.text = "空欄です"
            favoriteNameTextFieldCursorSetup(type: .error)
            return
        }
        
        // お気に入りの仕様を作成
        let serviceItem = ConstStruct.CollectionCell(title: favoriteText,
                                                     id: .favorite,
                                                     iconSystemName: "questionmark.folder",
                                                     lockIconSystemName: nil,
                                                     url: urlString)
        
        // 保存
        dataManager.addContentsMenuLists(menuItem: serviceItem)
        
        dismiss(animated: true, completion: nil)
        
        // Analytics
        Analytics.logEvent("FavoriteView", parameters: ["url": urlString])
    }
    
    // MARK: - Private
    /// TextFieldの種類(TextFieldのtagで判断するため、Int型)
    enum FieldType: Int {
        case url = 0
        case favorite = 1
    }
    enum cursorType {
        case normal
        case focus
        case error
    }
    private func urlTextFieldCursorSetup(type: cursorType) {
        switch type {
            case .normal:
                urlUnderLine.backgroundColor = .lightGray

            case .focus:
                // カーソルの色
                urlTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                urlUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)

            case .error:
                urlTextField.tintColor = .red
                urlUnderLine.backgroundColor = .red
        }
    }
    
    private func favoriteNameTextFieldCursorSetup(type: cursorType) {
        switch type {
                
            case .normal:
                favoriteUnderLine.backgroundColor = .lightGray
                
            case .focus:
                favoriteTextField.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                favoriteUnderLine.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                
            case .error:
                favoriteTextField.tintColor = .red
                favoriteUnderLine.backgroundColor = .red
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension FavoriteViewController: UITextFieldDelegate {
    
    // textField編集前
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // textFieldTag = 0はfieldType = .url
        if textField.tag == 0 {
            urlTextFieldCursorSetup(type: .focus)
        } else {
            favoriteNameTextFieldCursorSetup(type: .focus)
        }
    }
    // textField編集後
    func textFieldDidEndEditing(_ textField: UITextField) {
        urlTextFieldCursorSetup(type: .normal)
        favoriteNameTextFieldCursorSetup(type: .normal)
    }
    
    // text内容が変更されるたびに
    func textFieldDidChangeSelection(_ textField: UITextField) {
        urlTextSizeLabel.text = "\(urlTextField.text?.count ?? 0)/100"
        favoriteTextSizeLabel.text = "\(favoriteTextField.text?.count ?? 0)/10"
    }
    
}


// キーボード関連
extension FavoriteViewController {
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
