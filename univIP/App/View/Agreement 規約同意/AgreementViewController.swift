//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit

final class AgreementViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var agreementButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 登録ボタンの角を丸める
        agreementButton.layer.cornerRadius = 5.0
        let filePath = R.file.agreementRtf()!
        textView.attributedText = Common.loadRtfFileContents(filePath)
        textView.textColor = .white
//        textView.font = UIFont.boldSystemFont(ofSize: 15)
//        textView.text = "「快適になる」をタップすると、プライバシーポリシーを理解し、サービス利用規約に同意したことになります。"
    }
    
    // MARK: - IBAction
    
    /// 同意ボタン
    /// 利用規約のバージョン更新を行う
    @IBAction func agreementButton(_ sender: Any) {
        // アプリ内に表示していた利用規約のバージョンを保存する。
        // (アプリ起動毎に、前回同意した利用規約のバージョンを照らし合わせる)
        dataManager.agreementVersion = ConstStruct.latestTermsVersion
        dismiss(animated: true, completion: nil)
    }
}
