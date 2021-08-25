//
//  PassWordSettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class PassWordSettingsViewController: UIViewController {
    //MARK:- @IBOutlet
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cAccountTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    var delegateMain : MainViewController?
    
    private let module = Module()
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
    }
    
    
    //MARK:- @IBAction
    @IBAction func registrationButton(_ sender: Any) {
//        var registrationTrigger1 = false
//        var registrationTrigger2 = false
        var text1 : String = ""
        var text2 : String = ""
        
        if let cAccountText = cAccountTextField.text{
//            if (textFieldEmputyConfirmation(text: cAccountText)){
//                registrationTrigger1 = true
                text1 = cAccountText
//            }
        }
        if let passWordText = passWordTextField.text{
//            if (textFieldEmputyConfirmation(text: passWordText)){
//                registrationTrigger2 = true
                text2 = passWordText
//            }
        }
        
        var labelText : String
        dataManager.cAccount = text1
        dataManager.passWord = text2
        labelText = "登録完了"
        
//        if (registrationTrigger1 && registrationTrigger2){
//            dataManager.cAccount = text1
//            dataManager.passWord = text2
//            labelText = "登録完了"
//        }else{
//            labelText = "登録失敗"
//        }
        
        label.text = labelText
        passWordTextField.text = ""
        self.delegateMain?.reloadURL(urlString: module.loginURL)
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
        if let url = R.file.passWordRtf() {
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
    
//    private func textFieldEmputyConfirmation(text : String) -> Bool{
//        switch text {
//        case "":
//            return false
//        case " ":
//            return false
//        case "  ":
//            return false
//        case "   ":
//            return false
//        case "　":
//            return false
//        case "　　":
//            return false
//        case "　　　":
//            return false
//        case " 　":
//            return false
//        case "　 ":
//            return false
//        default:
//            return true
//        }
//    }
    
    //MARK:- Override
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

