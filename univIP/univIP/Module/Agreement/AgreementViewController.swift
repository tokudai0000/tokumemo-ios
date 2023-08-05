//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit
import RxCocoa
import RxSwift

final class AgreementViewController: UIViewController {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!
    @IBOutlet private weak var agreementButton: UIButton!

    private let disposeBag = DisposeBag()

    var viewModel: AgreementViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
        configureDefaults()
        configureImageView()
        configureButton()
        binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.accept(())
    }
}

// MARK: Binding
private extension AgreementViewController {
    func binding() {
        termsButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.termsButtonTapped.accept(())
            }
            .disposed(by: disposeBag)

        privacyButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.privacyButtonTapped.accept(())
            }
            .disposed(by: disposeBag)

        agreementButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.agreementButtonTapped.accept(())
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension AgreementViewController {
    private func configureDefaults() {
        textView.layer.cornerRadius = 10.0
        view.backgroundColor = .white
    }

    private func configureImageView() {
        iconImageView.image = UIImage(resource: R.image.tokumemoPlusIcon)
        iconImageView.layer.cornerRadius = 50.0
    }

    private func configureButton() {
        agreementButton.setTitle(NSLocalizedString("agreement button", comment: ""), for: .normal)
        agreementButton.backgroundColor = UIColor(resource: R.color.subColor)
        agreementButton.tintColor = .black
        agreementButton.layer.cornerRadius = 5.0
        agreementButton.layer.borderWidth = 1

        termsButton.setTitle(NSLocalizedString("term button", comment: ""), for: .normal)
        termsButton.backgroundColor = .white
        termsButton.borderColor = .black
        termsButton.tintColor = .black
        termsButton.layer.cornerRadius = 10.0
        termsButton.layer.borderWidth = 1

        privacyButton.setTitle(NSLocalizedString("privacy policy button", comment: ""), for: .normal)
        privacyButton.backgroundColor = .white
        privacyButton.borderColor = .black
        privacyButton.tintColor = .black
        privacyButton.layer.cornerRadius = 10.0
        privacyButton.layer.borderWidth = 1
    }

    private func setupText() {
//        let filePath = R.file
//        textView.attributedText = Common.loadRtfFileContents(filePath)
    }
}
