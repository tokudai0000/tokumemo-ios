//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit

final class AgreementViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var agreementButton: UIButton!
    
    private let dataManager = DataManager.singleton
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupText()
    }
    
    // MARK: - IBAction
    
    /// 同意ボタン  利用規約のバージョン更新も行う
    @IBAction func agreementButton(_ sender: Any) {
        // アプリ内に表示していた利用規約のバージョンを保存する。
        dataManager.agreementVersion = ConstStruct.latestTermsVersion
        let vc = R.storyboard.main.mainViewController()!
        present(vc, animated: false)
    }
    
    @IBAction func termsButton(_ sender: Any) {
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = Url.termsOfService.string()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pribacyButton(_ sender: Any) {
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = Url.privacyPolicy.string()
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Methods [Private]
    
    private func setupDefaults() {
        agreementButton.layer.cornerRadius = 5.0
        termsButton.layer.cornerRadius = 10.0
        privacyButton.layer.cornerRadius = 10.0
        textView.layer.cornerRadius = 10.0
        imageView.layer.cornerRadius = 100.0
    }
    
    private func setupText() {
        let filePath = R.file.agreementRtf()!
        textView.attributedText = Common.loadRtfFileContents(filePath)
        textView.textColor = .white
    }
}
