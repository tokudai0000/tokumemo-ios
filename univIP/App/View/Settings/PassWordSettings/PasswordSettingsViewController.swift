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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cAccountTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    var delegateMain : MainViewController?
    
    private let model = Model()
//    private var dataManager = DataManager()
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 20.0
        passWordTextField.placeholder = "PassWord"
        cAccountTextField.delegate = self
        passWordTextField.delegate = self
        
        rtfFileOpen()
        
        if DataManager.singleton.cAccount == ""{
            cAccountTextField.placeholder = "cアカウント"
            label.text = "入力してください"
        }else{
            cAccountTextField.text = DataManager.singleton.cAccount
            label.text = "すでに登録済みです(上書き可能)"
        }
    }
    
    
    //MARK:- IBAction
    @IBAction func registrationButton(_ sender: Any) {
        
        if let cAccountText = cAccountTextField.text{
            DataManager.singleton.cAccount = cAccountText
        }
        if let passWordText = passWordTextField.text{
            DataManager.singleton.password = passWordText
        }
        
        label.text = "登録完了"
        passWordTextField.text = ""
        
//        self.delegateMain?.openUrl(urlForRegistrant: model.urls["login"]!.url, urlForNotRegistrant: model.urls["systemServiceList"]!.url, alertTrigger: false)
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
    
    private func rtfFileOpen(){
        if let url = R.file.passwordRtf() {
            do {
                let terms = try Data(contentsOf: url)
                let attributeString = try NSAttributedString(data: terms,
                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                                             documentAttributes: nil)
                textView.attributedText = attributeString // 情報の保存方法について
            } catch let error {
                print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
            }
        }
    }
}

// MARK:- TextField
extension PasswordSettingsViewController:UITextFieldDelegate{
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
}

