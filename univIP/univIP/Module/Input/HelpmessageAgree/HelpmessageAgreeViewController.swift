//
//  HelpmessageAgreeViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/20.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class HelpmessageAgreeViewController: UIViewController {
    @IBOutlet private weak var textView: UITextView!

    private let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)

    private let disposeBag = DisposeBag()

    var viewModel: HelpmessageAgreeViewModelInterface!


    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaults()
        configureNavigation()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }
}

// MARK: Binding
private extension HelpmessageAgreeViewController {
    func binding() {
        leftBarButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapBackButton.accept(())
            }
            .disposed(by: disposeBag)

        viewModel.output
            .textView
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.textView.text = text
            }
            .disposed(by: disposeBag)
    }
}


// MARK: Layout
private extension HelpmessageAgreeViewController {
    func configureDefaults() {
    }

    func configureNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.title = "同意書"
//        navigationItem.rightBarButtonItem?.tintColor = .white
//        setEdgeSwipeBackIsActive(to: true)
    }
}
