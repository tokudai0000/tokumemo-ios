//
//  AboutThisAppViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class AboutThisAppViewController: BaseViewController {
    //MARK:- IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        textView.isSelectable = true
        rtfFileOpen()
    }
    
    
    // MARK:- Private func
    private func rtfFileOpen(){
        if let url = R.file.aboutThisAppRtf() {
            do {
                let terms = try Data(contentsOf: url)
                let attributedString = try NSAttributedString(data: terms,
                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                                             documentAttributes: nil)
                
                let linkFireBasePrivacy = (attributedString.string as NSString).range(of: "https://firebase.google.com/support/privacy?hl=ja")
                let linkLicense = (attributedString.string as NSString).range(of: " akidon0000")
                let linkSourceCode = (attributedString.string as NSString).range(of: "https://github.com/akidon0000/univIP")
                let linkPrivacyPolicy = (attributedString.string as NSString).range(of: "https://github.com/akidon0000/univIP/blob/main/userPolicy.txt")
                
                let attributedText = NSMutableAttributedString(string: attributedString.string)
                
                attributedText.addAttribute(.link, value: "https://firebase.google.com/support/privacy?hl=ja", range: linkFireBasePrivacy)
                attributedText.addAttribute(.link, value: "https://github.com/akidon0000/univIP/blob/main/LICENSE", range: linkLicense)
                attributedText.addAttribute(.link, value: "https://github.com/akidon0000/univIP", range: linkSourceCode)
                attributedText.addAttribute(.link, value: "https://github.com/akidon0000/univIP/blob/main/userPolicy.txt", range: linkPrivacyPolicy)
                
                textView.attributedText = attributedText
            } catch let error {
                print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
            }
        }
    }
}
