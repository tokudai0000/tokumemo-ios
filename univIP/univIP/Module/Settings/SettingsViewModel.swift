//
//  SettingsViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/12/10.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol SettingsViewModelInterface: AnyObject {
    var input: SettingsViewModel.Input { get }
    var output: SettingsViewModel.Output { get }
}

final class SettingsViewModel: BaseViewModel<SettingsViewModel>, SettingsViewModelInterface {

    struct Input: InputType {
        let didTapSettingsItem = PublishRelay<IndexPath>()
    }

    struct Output: OutputType {
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: SettingsRouterInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        
        input.didTapSettingsItem
            .subscribe { index in
                guard let index = index.element else {
                    return
                }
                let tappedCell = AppConstants().settingsItems[index.section][index[1]]
                if tappedCell.id == .password {
                    dependency.router.navigate(.modal(InputRouter()))
                    return
                }

                if tappedCell.id == .acknowledgements {
                    dependency.router.navigate(.modal(CreditsRouter()))
                    return
                }

                if let url = tappedCell.targetUrl {
                    dependency.router.navigate(.goWeb(url))
                }
            }
            .disposed(by: disposeBag)

        return .init(
        )
    }
}
