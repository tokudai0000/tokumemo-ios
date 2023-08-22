//
//  PRViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/12/16.
//

import UIKit
import RxCocoa
import RxSwift

class PRViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var clientNameLabel: UILabel!
    @IBOutlet private weak var imageDescriptionTextView: UITextView!
    @IBOutlet private weak var detailsInfoButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!

    private let disposeBag = DisposeBag()
    
    var viewModel: PRViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefault()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }
}

// MARK: Binding
private extension PRViewController {
    func binding() {
        detailsInfoButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapDetailsInfoButton.accept(())
            }
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapCloseButton.accept(())
            }
            .disposed(by: disposeBag)

        viewModel.output
            .imageUrlStr
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, imageUrlStr in
                if let imageUrl = URL(string: imageUrlStr) {
                    owner.imageView.loadImage(from: imageUrl)
                }
            }
            .disposed(by: disposeBag)

        viewModel.output
            .clientName
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.clientNameLabel.text = text
            }
            .disposed(by: disposeBag)

        viewModel.output
            .imageDescription
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.imageDescriptionTextView.text = text
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension PRViewController {
    func configureDefault() {
        imageDescriptionTextView.layer.cornerRadius = 15
        detailsInfoButton.layer.cornerRadius = 20
    }
}
