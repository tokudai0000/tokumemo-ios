//
//  BaseViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import UIKit
import RxCocoa
import RxSwift

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()

    func bindButtonTapEvent(_ button: UIButton, to input: PublishRelay<Void>) {
        button.rx.tap
            .bind(to: input)
            .disposed(by: disposeBag)
    }
}
