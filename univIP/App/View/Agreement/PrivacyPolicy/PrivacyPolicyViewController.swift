//
//  PrivacyPolicyViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/12.
//

import UIKit
import FirebaseAnalytics

class PrivacyPolicyViewController: UIViewController {
    
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
    
    
    // MARK: - Private
    private func setup() {
        Analytics.logEvent("privacyPolicyViewOpen", parameters: nil) // Analytics: 調べる・タップ
        
        textView.isEditable = false
        textView.isSelectable = true
    }
    
    private func textViewSetup() {
        guard let filePath = R.file.privacyPolicyRtf() else {
            return // faitalで落とすべきか？
        }
        
        textView.attributedText = Common.rtfFileLoad(url: filePath)
    }
    
}
