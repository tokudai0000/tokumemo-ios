//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit

final class AgreementViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var agreementButton: UIButton!
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
        agreementButton.layer.cornerRadius = 20.0
        
        // 同意規約内容の読み込み
        let filePath = R.file.agreementRtf()!
        let attributedText = Common.rtfFileLoad(url: filePath)
        textView.attributedText = Common.setAttributedText(attributedText)
    }
    
    
    // MARK: - IBAction
    @IBAction func agreementButton(_ sender: Any) {
        // 利用規約のバージョン更新
        dataManager.agreementVersion = model.agreementVersion
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - UITextViewDelegate
extension AgreementViewController: UITextViewDelegate {
    
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
