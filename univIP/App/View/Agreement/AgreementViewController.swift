//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit

final class AgreementViewController: BaseViewController, UITextViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var agreementButton: UIButton!
    
    private let model = Model()
    private let rtfFileModel = FileModel()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        textViewSetup()
    }
    
    
    // MARK: - IBAction
    @IBAction func buttonAction(_ sender: Any) {
//        dataManager.setAgreementVersion()
        dataManager.agreementVersion = model.agreementVersion
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
        agreementButton.layer.cornerRadius = 20.0
        
        termsTextView.isEditable = false
        termsTextView.isScrollEnabled = false
        termsTextView.isSelectable = true
        termsTextView.delegate = self
        
    }
    
    private func textViewSetup() {

        let attributed = rtfFileModel.rtfFileLoad(url: R.file.agreementRtf())
        let attributedString = NSMutableAttributedString(string: attributed.string)
        
        let linkSourceCode = (attributedString.string as NSString).range(of: "ご利用規約")
        let linkFireBasePrivacy = (attributedString.string as NSString).range(of: "プライバシーポリシー")
        
        let attributedText = NSMutableAttributedString(string: attributedString.string)
        attributedText.addAttribute(.link, value: "TermsOfService", range: linkSourceCode)
        attributedText.addAttribute(.link, value: "PrivacyPolicy", range: linkFireBasePrivacy)
        termsTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
        termsTextView.attributedText = attributedText
    }
    
}
