//
//  TermsOfServiceViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/12.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    private let rtfFileModel = RtfFileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
//        textView.isScrollEnabled = false
        textView.isSelectable = true
//        textView.delegate = self
        
        textView.attributedText = rtfFileModel.load(url: R.file.agreementRtf())
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
