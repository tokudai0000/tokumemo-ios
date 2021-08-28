//
//  ContactToDeveloperViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

//import MessageUI


class ContactToDeveloperViewController: BaseViewController,UITextViewDelegate  {
    //MARK:- @IBOutlet
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var coverLabel: UILabel!
    
    private var model = Model()
    
    private var processingDecision = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        coverLabel.isHidden = false
//        if bodyTextView.text.count != 0{
//            coverLabel.isHidden = true
//        }
    }
    
    //MARK:- @IBAction
    @IBAction func CoverLabelTop(_ sender: Any) {
        coverLabel.isHidden = true              // CoverLabelを非表示
        bodyTextView.becomeFirstResponder()     // LinesTxtView入力キーボードを表示させる
    }
    
    @IBAction func sendButton(_ sender: Any) {
        sendButton.isEnabled = false // 無効
        
        if (processingDecision){
            return
        }
        
        guard let mailBodyText = bodyTextView.text else {
            bodyTextView.text = ""
            label.text = "入力してください"
            sendButton.isEnabled = true // 無効
            return
        }
        
        if (textFieldEmputyConfirmation(text: mailBodyText)){
            bodyTextView.text = ""
            label.text = "入力してください"
            sendButton.isEnabled = true // 無効
            return
        }
        
        label.text = "送信中です・・・・・・・"

        processingDecision = true
        sendEmail(message: mailBodyText)
    }
    
    
    //MARK:- Private func
    private func sendEmail(message:String) {
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = model.mailMasterAddress
        
        //パスワードをenvTxtから取得
        if let url = R.file.envTxt() {
            do {
                let textData = try String(contentsOf: url, encoding: String.Encoding.utf8)
                smtpSession.password = textData
                print("成功")
            } catch let error as NSError{
                //　tryが失敗した時に実行される
                print("読み込み失敗: \(error)" )
            }
        }
        
        smtpSession.port = 465
        smtpSession.isCheckCertificateEnabled = false
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "Developer", mailbox: model.mailMasterAddress)!]
        builder.header.from = MCOAddress(displayName: "Customer", mailbox: "")
        builder.header.subject = model.mailSendTitle
        builder.htmlBody = message
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data!)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(String(describing: error))")
                self.toast(message: "送信に失敗しました。失敗が続く場合は[universityinformationportalapp@gmail.com]へ直接連絡をしてください。", type: "bottom", interval: 10.0)
                self.label.text = ""
            } else {
                NSLog("Successfully sent email!")
                self.label.text = "送信しました。"
            }
        }
        processingDecision = false
        sendButton.isEnabled = true // 有効
    }
}
