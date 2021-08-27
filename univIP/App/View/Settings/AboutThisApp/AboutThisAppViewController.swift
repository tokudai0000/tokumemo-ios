//
//  AboutThisAppViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class AboutThisAppViewController: BaseViewController {
    //MARK:- @IBOutlet
    @IBOutlet weak var textView: UITextView!
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rtfFileOpen()
    }
    
    
    //MARK:- @IBAction
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Private func
    private func rtfFileOpen(){
        if let url = R.file.aboutThisAppRtf() {
            do {
                let terms = try Data(contentsOf: url)
                let attributeString = try NSAttributedString(data: terms,
                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                                             documentAttributes: nil)
                              
                textView.attributedText = attributeString
            } catch let error {
                print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
            }
        }
    }
}
