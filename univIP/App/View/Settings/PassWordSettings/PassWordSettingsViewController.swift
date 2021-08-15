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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cAccountTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var viewTop: UIView!
    
    
    private var dataManager = DataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.viewTop.layer.position.x -= 250
        },
            completion: { bool in
        })
        
        if let url = R.file.passWordRtf() {
            do {
                let terms = try Data(contentsOf: url)
                let attributeString = try NSAttributedString(data: terms,
                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                                             documentAttributes: nil)
                
                textView.attributedText = attributeString
            } catch let error {
                print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
            }
        }
        
        var cAcountText = dataManager.cAccount
        label.text = "すでに登録済みです(上書き可能)"
        if (cAcountText == ""){
            cAcountText = "cアカウント"
            label.text = ""
        }
        cAccountTextField.placeholder = cAcountText
        passWordTextField.placeholder = "PassWord"
        
    }
    
    //MARK:- @IBAction
    @IBAction func registrationButton(_ sender: Any) {
        dataManager.cAccount = cAccountTextField.text ?? ""
        dataManager.passWord = passWordTextField.text ?? ""
        //        cAccountTextField.text = ""
        passWordTextField.text = ""
        label.text = "登録完了"
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.5,
            delay: 0.08,
            options: .curveEaseOut,
            animations: {
                self.viewTop.layer.position.x += 250
        },
            completion: { bool in
        })
        let vc = R.storyboard.settings.settingsViewController()!
        self.present(vc, animated: false, completion: nil)
        vc.delegatePass = self // restoreViewをSettingsVCから呼び出させるため
    }
    
    //MARK:- Override
    // キーボード非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    
}

