//
//  AboutThisAppViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class AboutThisAppViewController: BaseViewController, UITextViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        textViewSetup()
    }
    
    
    // MARK: - IBAction
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
        textView.delegate = self
        textView.isSelectable = true
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
    }
    
    private func textViewSetup() {
        guard let filePath = R.file.aboutThisAppRtf() else {
            return // faitalで落とすべきか？
        }
        
        let attributedText = Common.rtfFileLoad(url: filePath)
        textView.attributedText = Common.setAttributedText(attributedText)
    }
    
}
