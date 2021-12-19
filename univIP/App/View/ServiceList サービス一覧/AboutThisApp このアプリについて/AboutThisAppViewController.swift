//
//  AboutThisAppViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class AboutThisAppViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // このアプリについて内容の読み込み
        let filePath = R.file.aboutThisAppRtf()!
        textView.attributedText = Common.rtfFileLoad(filePath)
    }
    
    
    // MARK: - IBAction
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func termsOfServiceButton(_ sender: Any) {
        let vc = R.storyboard.termsOfService.termsOfService()!
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyButton(_ sender: Any) {
        let vc = R.storyboard.privacyPolicy.privacyPolicy()!
        present(vc, animated: true, completion: nil)
    }
    
}
