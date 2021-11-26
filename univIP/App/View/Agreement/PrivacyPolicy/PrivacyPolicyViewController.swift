//
//  PrivacyPolicyViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/12.
//

import UIKit
import FirebaseAnalytics

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("privacyPolicyViewOpen", parameters: nil) // Analytics: 調べる・タップ

        textView.isEditable = false
        textView.isSelectable = true
        
        
        guard let filePath = R.file.privacyPolicyRtf() else {
            return // faitalで落とすべきか？
        }

        let attributed = Common.rtfFileLoad(url: filePath)
        
        let attributedText = NSMutableAttributedString(string: attributed.string,
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
