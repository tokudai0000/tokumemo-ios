//
//  PassWordSettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class PasswordSettingsViewController: BaseViewController ,UITextFieldDelegate{
    //MARK:- @IBOutlet
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cAccountTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    var delegateMain : MainViewController?
    
    private let model = Model()
    private var dataManager = DataManager()
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rtfFileOpen()
        
        var labelText : String
        if (dataManager.cAccount == ""){
            cAccountTextField.placeholder = "cアカウント"
            labelText = "入力してください"
        }else{
            cAccountTextField.text = dataManager.cAccount
            labelText = "すでに登録済みです(上書き可能)"
        }
        label.text = labelText
        passWordTextField.placeholder = "PassWord"
        cAccountTextField.delegate = self
        passWordTextField.delegate = self
    }
    
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
    
    
    //MARK:- @IBAction
    @IBAction func registrationButton(_ sender: Any) {
        var text1 : String = ""
        var text2 : String = ""
        
        if let cAccountText = cAccountTextField.text{
            text1 = cAccountText
        }
        if let passWordText = passWordTextField.text{
            text2 = passWordText
        }
        
        var labelText : String
        dataManager.cAccount = text1
        dataManager.passWord = text2
        labelText = "登録完了"
        
        
        label.text = labelText
        passWordTextField.text = ""
        self.delegateMain?.openUrl(urlForRegistrant: model.loginURL, urlForNotRegistrant: nil, alertTrigger: false)
    }
    
    
    // MARK: - Public func
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
    
    
    // MARK: - Private func
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

