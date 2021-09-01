//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit

class AgreementViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonTextureYes: UIButton!
    @IBOutlet weak var buttonTextureNo: UIButton!
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonTextureYes.layer.cornerRadius = 20.0
        buttonTextureNo.layer.cornerRadius = 20.0
        
        rtfFileOpen()
    }
    
    
    //MARK:- IBAction
    @IBAction func buttonAction(_ sender: Any) {
        // tag 0:Yes  1:No
        if let button = sender as? UIButton {
            switch button.tag {
            case 0:
                // 利用規約に同意した
                UserDefaults.standard.set(true, forKey: "FirstBootDecision")
                dismiss(animated: false, completion: nil)
            case 1:
                toast(message: "申し訳ありません。同意をしない限り、このアプリを利用することはできません", type: "bottom")
                
            default:
                return
            }
        }
    }
    
    
    // MARK: - Private func
    private func rtfFileOpen(){
        if let url = R.file.agreementRtf() {
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
