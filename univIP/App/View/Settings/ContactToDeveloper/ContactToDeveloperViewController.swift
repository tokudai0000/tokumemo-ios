//
//  ContactToDeveloperViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit

import MessageUI

class ContactToDeveloperViewController: UIViewController,MFMailComposeViewControllerDelegate  {
    
    
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
    
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func sendButton(_ sender: Any) {
        sendMail()
        
        
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //新規メールを開く
    func sendMail() {
        //メール送信が可能なら
        if MFMailComposeViewController.canSendMail() {
            //MFMailComposeVCのインスタンス
            let mail = MFMailComposeViewController()
            //MFMailComposeのデリゲート
            mail.mailComposeDelegate = self
            //送り先
            mail.setToRecipients(["universityinformationportalapp@gmail.com"])
            //Cc
//            mail.setCcRecipients(["mike@gmail.com"])
            //Bcc
//            mail.setBccRecipients(["amy@gmail.com"])
            //件名
            mail.setSubject("件名")
            //メッセージ本文
            mail.setMessageBody("このメールはMFMailComposeViewControllerから送られました。", isHTML: false)
            //メールを表示
            self.present(mail, animated: true, completion: nil)
            //メール送信が不可能なら
        } else {
            //アラートで通知
            let alert = UIAlertController(title: "No Mail Accounts", message: "Please set up mail accounts", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(dismiss)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //エラー処理
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            //送信失敗
            print(error)
        } else {
            switch result {
            case .cancelled: break
            //キャンセル
            case .saved: break
            //下書き保存
            case .sent: break
            //送信
            default:
                break
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
}
