//
//  AboutThisAppViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class AboutThisAppViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
        
        // このアプリについて内容の読み込み
        let filePath = R.file.aboutThisAppRtf()!
        let attributedText = Common.rtfFileLoad(url: filePath)
        textView.attributedText = Common.setAttributedText(attributedText)
    }
    
    
    // MARK: - IBAction
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}


// MARK: - UITextViewDelegate
extension AboutThisAppViewController: UITextViewDelegate {
    
    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {
        
        let urlString = URL.absoluteString
        
        switch urlString {
        case "TermsOfService":
            let vc = R.storyboard.termsOfService.termsOfService()!
            present(vc, animated: true, completion: nil)
            return false // 通常のURL遷移を行わない
            
        case "PrivacyPolicy":
            let vc = R.storyboard.privacyPolicy.privacyPolicy()!
            present(vc, animated: true, completion: nil)
            return false
            
        default:
            return true // 通常のURL遷移を行う
        }
    }
    
}
