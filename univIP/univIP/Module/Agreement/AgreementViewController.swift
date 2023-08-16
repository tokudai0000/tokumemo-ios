//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit
import RxCocoa
import RxSwift

final class AgreementViewController: BaseViewController {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!
    @IBOutlet private weak var agreementButton: UIButton!

    var viewModel: AgreementViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaults()
        configureImageView()
        configureButton()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }
}

// MARK: Binding
private extension AgreementViewController {

    func binding() {
        bindButtonTapEvent(termsButton, to: viewModel.input.didTapTermsButton)
        bindButtonTapEvent(privacyButton, to: viewModel.input.didTapPrivacyButton)
        bindButtonTapEvent(agreementButton, to: viewModel.input.didTapAgreementButton)

        viewModel.output
            .termText
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.textView.text = text
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension AgreementViewController {

    func configureDefaults() {
        textView.layer.cornerRadius = 10.0
        view.backgroundColor = .white
    }

    func configureImageView() {
        iconImageView.image = UIImage(resource: R.image.tokumemoPlusIcon)
        iconImageView.layer.cornerRadius = 50.0
    }

    func configureButton() {
        agreementButton.setTitle(R.string.localizable.agree(), for: .normal)
        agreementButton.backgroundColor = UIColor(resource: R.color.subColor)
        agreementButton.tintColor = .black
        agreementButton.layer.cornerRadius = 5.0
        agreementButton.layer.borderWidth = 1

        termsButton.setTitle(R.string.localizable.terms_of_service(), for: .normal)
        termsButton.backgroundColor = .white
        termsButton.borderColor = .black
        termsButton.tintColor = .black
        termsButton.layer.cornerRadius = 10.0
        termsButton.layer.borderWidth = 1

        privacyButton.setTitle(R.string.localizable.privacy_policy(), for: .normal)
        privacyButton.backgroundColor = .white
        privacyButton.borderColor = .black
        privacyButton.tintColor = .black
        privacyButton.layer.cornerRadius = 10.0
        privacyButton.layer.borderWidth = 1
    }
}
