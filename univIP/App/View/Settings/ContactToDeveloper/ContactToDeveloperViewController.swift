//
//  ContactToDeveloperViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit

//import MessageUI


class ContactToDeveloperViewController: UIViewController,UITextViewDelegate  {
    
    var module = Module()
    
    @IBOutlet weak var backButton: UIBarButtonItem!{
        didSet {
            backButton.isEnabled = false
            backButton.tintColor = UIColor.blue.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var forwardButton: UIBarButtonItem! {
        didSet {
            forwardButton.isEnabled = false
            forwardButton.tintColor = UIColor.blue.withAlphaComponent(0.4)
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var bodyTextView: UITextView!
    let master_mail = "universityinformationportalapp@gmail.com"
    let master_pass = "5hy7wt66qwwfftxpkoas"
    let display_name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let text1 = ""
    let text2 = " "
    let text3 = "　"
    let text4 = "送信に失敗しました。失敗が続く場合は[universityinformationportalapp@gmail.com]へ連絡をしてください。"
//    let text3 = "送信しました。"
    
    @IBAction func sendButton(_ sender: Any) {
        if (module.hasPassdThroughOnce){
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

        module.hasPassdThroughOnce = true
        sendEmail(message: mailText)
        
        
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        outputText.text = inputText.text
        self.view.endEditing(true)
    }
    
    
    
    func sendEmail(message:String)
    {
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = master_mail
        smtpSession.password = master_pass
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
        builder.header.subject = "トクメモ開発者へ"
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
        module.hasPassdThroughOnce = false
        
    }
    
    
//    func sendEmail(message:String){
//        let smtpSession = MCOSMTPSession()
//        let master_mail = "universityinformationportalapp@gmail.com"
//        let master_pass = "5hy7wt66qwwfftxpkoas"
//        let display_name = "test"
//        smtpSession.hostname = "smtp.gmail.com"
//        smtpSession.username = master_mail
//        smtpSession.password = master_pass
//        smtpSession.port = 465
//        smtpSession.isCheckCertificateEnabled = false
//        smtpSession.authType = MCOAuthType.saslPlain
//        smtpSession.connectionType = MCOConnectionType.TLS
//        smtpSession.connectionLogger = {(connectionID, type, data) in
//            if data != nil {
//                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
//                    NSLog("Connectionlogger: \(string)")
//                }
//            }
//        }
//
//        let builder = MCOMessageBuilder()
//        builder.header.to = [MCOAddress(displayName: display_name, mailbox: master_mail) ?? ""]
//        builder.header.from = MCOAddress(displayName: display_name, mailbox: master_mail)
//        builder.header.subject = "タイトル"
//        builder.htmlBody = message
//
//        let rfc822Data = builder.data()
//        let sendOperation = smtpSession.sendOperation(with: rfc822Data!)
//        sendOperation?.start { (error) -> Void in
//            if (error != nil) {
//                NSLog("Error sending email: \(String(describing: error))")
//            } else {
//                NSLog("Successfully sent email!")
//            }
//        }
//    }
    
    
}
