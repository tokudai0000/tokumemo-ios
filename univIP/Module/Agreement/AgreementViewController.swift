//
//  AgreementViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/31.
//

import UIKit
import RxSwift
import NorthLayout

final class AgreementViewController: UIViewController {
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: R.image.icon_tokumemo_plus)
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        return imageView
    }()

    private var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = R.color.ultraGrayColor()
        textView.layer.cornerRadius = 10.0
        textView.textAlignment = .center
        textView.isEditable = false
        return textView
    }()

    private var termsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(R.string.localizable.terms_of_service(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        return button
    }()

    private var privacyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(R.string.localizable.privacy_policy_button(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        return button
    }()

    private var agreementButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = R.color.subColor()
        button.setTitle(R.string.localizable.agree(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5.0
        return button
    }()


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
