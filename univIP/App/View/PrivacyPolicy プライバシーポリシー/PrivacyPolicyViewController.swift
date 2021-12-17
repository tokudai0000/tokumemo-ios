//
//  PrivacyPolicyViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/12.
//

import UIKit

final class PrivacyPolicyViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = R.file.privacyPolicyRtf()!
        textView.attributedText = Common.rtfFileLoad(url: filePath)
    }
    
    
    // MARK: - IBAction
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
