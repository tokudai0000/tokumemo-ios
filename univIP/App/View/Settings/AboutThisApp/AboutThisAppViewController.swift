//
//  AboutThisAppViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class AboutThisAppViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        textViewSetup()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Public
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let urlString = URL.absoluteString
        
        if urlString == "TermsOfService" {
            let vc = R.storyboard.termsOfService.termsOfService()!
            self.present(vc, animated: true, completion: nil)
            return false // 通常のURL遷移を行わない
            
        } else if urlString == "PrivacyPolicy" {
            let vc = R.storyboard.privacyPolicy.privacyPolicy()!
            self.present(vc, animated: true, completion: nil)
            return false
            
        }
        return true // 通常のURL遷移を行う
        
    }
    
    
    // MARK: - Private
    private func setup() {
        
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = self
        
    }
    
    private func textViewSetup() {
        
        guard let filePath = R.file.aboutThisAppRtf() else {
            return // faitalで落とすべきか？
        }

        let attributed = Common.rtfFileLoad(url: filePath)
        let attributedString = NSMutableAttributedString(string: attributed.string)
        
        let linkSourceCode = (attributedString.string as NSString).range(of: "ご利用規約")
        let linkFireBasePrivacy = (attributedString.string as NSString).range(of: "プライバシーポリシー")
        
        let attributedText = NSMutableAttributedString(string: attributedString.string,
                                                       attributes:[
                                                        .font:UIFont(name: "Futura-Medium", size:15)!,
                                                        .foregroundColor:UIColor.label,
                                                       ])
        attributedText.addAttribute(.link, value: "TermsOfService", range: linkSourceCode)
        attributedText.addAttribute(.link, value: "PrivacyPolicy", range: linkFireBasePrivacy)
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
        textView.attributedText = attributedText
    }
}
