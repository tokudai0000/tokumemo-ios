//
//  ClubListViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol ClubListViewModelInterface: AnyObject {
    var input: ClubListViewModel.Input { get }
    var output: ClubListViewModel.Output { get }
}

final class ClubListViewModel: BaseViewModel<ClubListViewModel>, ClubListViewModelInterface {

    struct Input: InputType {
        let didTapWebLink = PublishRelay<String>()
    }

    struct Output: OutputType {
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: ClubListRouterInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {

        input.didTapWebLink
            .subscribe { urlStr in
                if let url = URL(string: urlStr) {
                    dependency.router.navigate(.goWeb(URLRequest(url: url)))
                }
            }
            .disposed(by: disposeBag)

        return .init(
        )
    }
}
