//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit

final class AgreementViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var termsOfServiceView: UITextView!
    @IBOutlet weak var agreementButtonYes: UIButton!
    @IBOutlet weak var agreementButtonNo: UIButton!
    
    private let model = Model()
    private let rtfFileModel = RtfFileModel()
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    private func setup() {
        agreementButtonYes.layer.cornerRadius = 20.0
        agreementButtonNo.layer.cornerRadius = 20.0
        
        termsOfServiceView.isEditable = false
        termsOfServiceView.attributedText = rtfFileModel.load(url: R.file.agreementRtf())
    }
    
    
    //MARK:- IBAction
    private enum buttonTag: Int {
        case agree = 1
        case dissAgree = 2
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
        if let button = sender as? UIButton,
           let tag = buttonTag(rawValue: button.tag){
            
            switch tag {
            case .agree:
                UserDefaults.standard.set(true, forKey: model.agreementVersion)
                dismiss(animated: false, completion: nil)
                
                
            case .dissAgree:
                toast(message: "同意をしない限り、このアプリを利用することはできません", type: "bottom")
                
            }
        }
    }
    
}
