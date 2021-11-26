//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit

final class AgreementViewController: BaseViewController, UITextViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var agreementButton: UIButton!
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        textViewSetup()
    }
    
    
    // MARK: - IBAction
    @IBAction func agreementButton(_ sender: Any) {
        // 利用規約のバージョン更新
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
        
        textView.delegate = self
        textView.isSelectable = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
    }
    
    private func textViewSetup() {
        guard let filePath = R.file.agreementRtf() else {
            return // faitalで落とすべきか？
        }

        let attributedText = Common.rtfFileLoad(url: filePath)
        
        textView.attributedText = Common.setAttributedText(attributedText)
    }
    
}
