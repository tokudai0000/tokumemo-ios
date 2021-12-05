//
//  TermsOfServiceViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/12.
//

import UIKit
import FirebaseAnalytics

class TermsOfServiceViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("termsOfServiceViewOpen", parameters: nil)
        
        let filePath = R.file.termsOfServiceRtf()!
        textView.attributedText = Common.rtfFileLoad(url: filePath)
    }
    
    
    // MARK: - IBAction
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
