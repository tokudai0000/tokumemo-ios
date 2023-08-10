//
//  PrViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/10.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol PrViewModelInterface: AnyObject {
    var input: PrViewModel.Input { get }
    var output: PrViewModel.Output { get }
}

final class PrViewModel: BaseViewModel<PrViewModel>, PrViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
    }

    struct Output: OutputType {
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: PrRouterInterface
        let prItem: AdItem
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {

        return .init(
        )
    }
}
