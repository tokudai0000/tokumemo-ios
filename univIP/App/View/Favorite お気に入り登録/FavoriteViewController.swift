//
//  FavoriteViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/02/16.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var favoriteTextSizeLabel: UILabel!
    @IBOutlet weak var favoriteNameTextField: UITextField!
    @IBOutlet weak var isFirstViewSetting: UISwitch!
    @IBOutlet weak var registerButton: UIButton!
    
    public var urlString: String?
    private let dataManager = DataManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = urlString {
            urlLabel.text = url
        }
        
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
        
        if isFirstViewSetting.isOn {
            var menuLists = dataManager.menuLists
            for i in 0..<menuLists.count {
                menuLists[i].isInitView = false
            }
            dataManager.menuLists = menuLists
            // menuListsをUserDefaultsに保存
            dataManager.saveMenuLists()
        }
        
        guard let text = favoriteNameTextField.text else {
            return
        }
        
        let menuItem = Constant.Menu(title: text,
                                     id: .favorite,
                                     url: urlString,
                                     isInitView: isFirstViewSetting.isOn,
                                     canInitView: true)
        // 保存
        dataManager.addContentsMenuLists(menuItem: menuItem)
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
