//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit

final class AgreementViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var agreementButton: UIButton!
    
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 同意規約内容の読み込み
        let filePath = R.file.agreementRtf()!
        textView.attributedText = Common.loadRtfFileContents(filePath)
    }
    
    
    // MARK: - IBAction
    @IBAction func termsOfServiceButton(_ sender: Any) {
        // 利用規約
        let vc = R.storyboard.termsOfService.termsOfService()!
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyButton(_ sender: Any) {
        // プライバシーポリシー
        let vc = R.storyboard.privacyPolicy.privacyPolicy()!
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func agreementButton(_ sender: Any) {
        // 利用規約のバージョン更新
        dataManager.agreementVersion = Constant.latestTermsVersion
        dismiss(animated: true, completion: nil)
    }
    
}
