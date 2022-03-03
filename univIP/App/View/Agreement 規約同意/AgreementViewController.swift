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
    /// 利用規約
    @IBAction func termsOfServiceButton(_ sender: Any) {
        let vc = R.storyboard.terms.termsViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    /// プライバシーポリシー
    @IBAction func privacyPolicyButton(_ sender: Any) {
        let vc = R.storyboard.privacyPolicy.privacyPolicyViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    /// 同意ボタン
    /// 利用規約のバージョン更新を行う
    @IBAction func agreementButton(_ sender: Any) {
        dataManager.agreementVersion = Constant.latestTermsVersion
        dismiss(animated: true, completion: nil)
    }
}
