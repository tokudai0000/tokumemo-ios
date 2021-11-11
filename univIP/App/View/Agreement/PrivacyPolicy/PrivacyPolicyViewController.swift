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
        
        textView.attributedText = rtfFileModel.rtfFileLoad(url: R.file.privacyPolicyRtf())
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
