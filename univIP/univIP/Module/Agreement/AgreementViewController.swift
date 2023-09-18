//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit
import RxSwift
import Ikemen
import NorthLayout

final class AgreementViewController: UIViewController {
    private var iconImageView = UIImageView() ※ {
        $0.image = UIImage(resource: R.image.icon_tokumemo_plus)
        $0.layer.cornerRadius = 50.0
        $0.clipsToBounds = true
    }
    private var textView = UITextView() ※ {
        $0.backgroundColor = R.color.ultraGrayColor()
        $0.layer.cornerRadius = 10.0
        $0.textAlignment = .center
    }
    private var termsButton = UIButton() ※ {
        $0.backgroundColor = .white
        $0.setTitle(R.string.localizable.terms_of_service(), for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.tintColor = .black
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10.0
    }
    private var privacyButton = UIButton() ※ {
        $0.backgroundColor = .white
        $0.setTitle(R.string.localizable.privacy_policy_button(), for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.tintColor = .black
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10.0
    }
    private var agreementButton = UIButton() ※ {
        $0.backgroundColor = R.color.subColor()
        $0.setTitle(R.string.localizable.agree(), for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        $0.tintColor = .black
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5.0
    }

    private let disposeBag = DisposeBag()
    
    var viewModel: AgreementViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }
}

// MARK: Binding
private extension AgreementViewController {
    func binding() {
        termsButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapTermsButton.accept(())
            }
            .disposed(by: disposeBag)

        privacyButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapPrivacyButton.accept(())
            }
            .disposed(by: disposeBag)

        agreementButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapAgreementButton.accept(())
            }
            .disposed(by: disposeBag)

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
    func configureView() {
        view.backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [termsButton, privacyButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20

        let autolayout = view.northLayoutFormat([:], [
            "iconImage": iconImageView,
            "text": textView,
            "stackView": stackView,
            "agreement": agreementButton
        ])
        autolayout("H:||-(>=0)-[iconImage(100)]-(>=0)-||")
        autolayout("H:|-5-[text]-5-|")
        autolayout("H:||-(>=0)-[stackView]-(>=0)-||")
        autolayout("H:||-(>=0)-[agreement(150)]-(>=0)-||")
        autolayout("V:||-[iconImage(100)]-5-[text]-5-[stackView]-10-[agreement]-10-||")

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            agreementButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
