//
//  ClubListsViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol ClubListsViewModelInterface: AnyObject {
    var input: ClubListsViewModel.Input { get }
    var output: ClubListsViewModel.Output { get }
}

final class ClubListsViewModel: BaseViewModel<ClubListsViewModel>, ClubListsViewModelInterface {

    struct Input: InputType {
        let didTapWebLink = PublishRelay<String>()
    }

    struct Output: OutputType {
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: ClubListsRouterInterface
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
