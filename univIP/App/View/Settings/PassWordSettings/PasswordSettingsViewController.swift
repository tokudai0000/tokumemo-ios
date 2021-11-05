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
    
    public var delegate : MainViewController?
    
    private let dataManager = DataManager.singleton
    private let model = Model()
    private let webViewModel = WebViewModel()
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        rtfFileOpen()
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
        
        delegate?.webView.load(webViewModel.url(.login)! as URLRequest)
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
    
    private func setup() {
        registerButton.layer.cornerRadius = 20.0
        passWordTextField.placeholder = "PassWord"
        cAccountTextField.delegate = self
        passWordTextField.delegate = self
        
        if dataManager.cAccount == ""{
            cAccountTextField.placeholder = "cアカウント"
            label.text = "入力してください"
        }else{
            cAccountTextField.text = dataManager.cAccount
            label.text = "すでに登録済みです(上書き可能)"
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

