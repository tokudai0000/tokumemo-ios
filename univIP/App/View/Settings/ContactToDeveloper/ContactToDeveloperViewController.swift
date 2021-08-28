//
//  ContactToDeveloperViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit


class ContactToDeveloperViewController: BaseViewController, UITextViewDelegate  {
    //MARK:- @IBOutlet
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var coverLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bodyTextView: UITextView!
    
    private var model = Model()

    private var processingDecision = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK:- @IBAction
    @IBAction func CoverLabelTop(_ sender: Any) {
        coverLabel.isHidden = true              // CoverLabelを非表示
        bodyTextView.becomeFirstResponder()     // LinesTxtView入力キーボードを表示させる
    }
    
    @IBAction func sendButton(_ sender: Any) {
        activityIndicator.startAnimating()
        
        view.bringSubviewToFront(activityIndicator)
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

        processingDecision = true
        
        sendEmail(message: mailBodyText)
    }


    //MARK:- Private func
    private func sendEmail(message:String) {
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = model.mailMasterAddress

        if let url = R.file.mailAccountPasswordTxt() {
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
        builder.header.to = [MCOAddress(displayName: "", mailbox: model.mailMasterAddress)!]
        builder.header.from = MCOAddress(displayName: "", mailbox: model.mailMasterAddress)
        builder.header.subject = model.mailSendTitle
        builder.htmlBody = message

        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data!)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(String(describing: error))")
                self.toast(message: self.model.mailSendFailureText, type: "top", interval: 10)
                self.label.text = ""
                self.activityIndicator.stopAnimating()
                self.processingDecision = false
                self.sendButton.isEnabled = true // 有効
            } else {
                NSLog("Successfully sent email!")
                self.toast(message: "送信に成功しました。", type: "top", interval: 3)
                self.label.text = ""
                self.activityIndicator.stopAnimating()
                self.processingDecision = false
                self.sendButton.isEnabled = true // 有効
            }
        }
    }
}
