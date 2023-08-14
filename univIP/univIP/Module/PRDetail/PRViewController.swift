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
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
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
        detailsInfoButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapDetailsInfoButton.accept(())
            }
            .disposed(by: disposeBag)

        closeButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapCloseButton.accept(())
            }
            .disposed(by: disposeBag)

        viewModel.output
            .imageStr
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, imageStr in
                if let url = URL(string: imageStr) {
                    owner.imageView.loadImage(from: url)
                }
            }
            .disposed(by: disposeBag)

        viewModel.output
            .clientName
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.textLabel.text = text
            }
            .disposed(by: disposeBag)

        viewModel.output
            .text
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.textView.text = text
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension PRViewController {
    func configureDefault() {
        textView.cornerRound = 15
        detailsInfoButton.cornerRound = 20
    }
}
