//
//  SplashViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol SplashViewModelInterface: AnyObject {
    var input: SplashViewModel.Input { get }
    var output: SplashViewModel.Output { get }
}

final class SplashViewModel: BaseViewModel<SplashViewModel>, SplashViewModelInterface {

    struct Input: InputType {
    }

    struct Output: OutputType {
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: SplashRouterInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {

        return .init(
        )
    }
}
