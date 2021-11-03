//
//  AgreementViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

final class AgreementViewModel: NSObject {
    
    func rtfFileOpen() -> NSMutableAttributedString{
        if let url = R.file.agreementRtf() {
            do {
                let terms = try Data(contentsOf: url)
                let attributedString = try NSAttributedString(data: terms,
                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                                             documentAttributes: nil)
                
                let linkSourceCode = (attributedString.string as NSString).range(of: "https://github.com/akidon0000/univIP")
                let linkFireBasePrivacy = (attributedString.string as NSString).range(of: "https://firebase.google.com/support/privacy?hl=ja")
                let attributedText = NSMutableAttributedString(string: attributedString.string)
                attributedText.addAttribute(.link, value: "https://github.com/akidon0000/univIP", range: linkSourceCode)
                attributedText.addAttribute(.link, value: "https://firebase.google.com/support/privacy?hl=ja", range: linkFireBasePrivacy)
                return attributedText
                        
            } catch let error {
                print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
            }
        }
        return NSMutableAttributedString()
    }
    
}

