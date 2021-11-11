//
//  AboutThisAppViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class AboutThisAppViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    private let rtfFileModel = FileModel()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isEditable = false
        textView.isSelectable = true
        textView.attributedText = rtfFileModel.rtfFileLoad(url: R.file.privacyPolicyRtf())
    }
    
}
