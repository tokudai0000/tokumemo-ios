//
//  PrivacyPolicyViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/12.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    private let rtfFileModel = FileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        textView.isSelectable = true
        
        let attributedText = NSMutableAttributedString(string: rtfFileModel.rtfFileLoad(url: R.file.privacyPolicyRtf()).string,
                                                       attributes:[
                                                        .font:UIFont(name:"Futura-Medium", size:15)!,
                                                        .foregroundColor:UIColor.label,
                                                       ])
        
        textView.attributedText = attributedText
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
