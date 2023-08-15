//
//  SplashViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import UIKit
import RxCocoa
import RxSwift

final class SplashViewController: UIViewController {

    private let disposeBag = DisposeBag()

    var viewModel: SplashViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaults()
        binding()
    }
}

// MARK: Binding
private extension SplashViewController {
    func binding() {
    }
}

// MARK: Layout
private extension SplashViewController {
    func configureDefaults() {
    }
}
