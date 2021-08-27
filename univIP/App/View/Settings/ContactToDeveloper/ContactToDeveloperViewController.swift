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
    
    private var model = Model()
    private let master_mail = "universityinformationportalapp@gmail.com"
    private let master_pass = "5hy7wt66qwwfftxpkoas"
    private let display_name = ""
    
    private let text1 = ""
    private let text2 = " "
    private let text3 = "　"
    private let text4 = "送信に失敗しました。失敗が続く場合は[universityinformationportalapp@gmail.com]へ連絡をしてください。"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private var hasPassdThroughOnce = false
    
    //MARK:- @IBAction
    @IBAction func sendButton(_ sender: Any) {
        sendButton.isEnabled = false // 無効
//        if (module.hasPassdThroughOnce){
//            return
//        }
        if (hasPassdThroughOnce){
            return
        }
        let mailText = bodyTextView.text ?? ""
        print(mailText)
        
        if (mailText == text1 || mailText == text2 || mailText == text3 || mailText == text4){
            bodyTextView.text = ""
            label.text = "入力してください"
            return
        }
        label.text = "送信中です・・・・・・・"

//        module.hasPassdThroughOnce = true
        hasPassdThroughOnce = true
        sendEmail(message: mailText)
    }
    
    
    //MARK:- Private func
    private func sendEmail(message:String) {
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = model.masterMail
        
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
        builder.header.to = [MCOAddress(displayName: display_name, mailbox: master_mail)!]
        builder.header.from = MCOAddress(displayName: display_name, mailbox: master_mail)
        builder.header.subject = model.mailTitle
        builder.htmlBody = message
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data!)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(String(describing: error))")
                self.bodyTextView.text = "送信に失敗しました。失敗が続く場合は[universityinformationportalapp@gmail.com]へ連絡をしてください。"
                self.label.text = ""
            } else {
                NSLog("Successfully sent email!")
                self.label.text = "送信しました。"
            }
        }
//        module.hasPassdThroughOnce = false
        hasPassdThroughOnce = false
        sendButton.isEnabled = true // 有効
    }
    
    //MARK:- Override
    // キーボード非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
