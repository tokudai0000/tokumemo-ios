//
//  AgreementViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/04.
//

import Foundation
import RxRelay
import RxSwift

protocol AgreementViewModelInterface: AnyObject {
    var input: AgreementViewModel.Input { get }
    var output: AgreementViewModel.Output { get }
}

/// ViewからのInputに応じで処理を行いOutputとして公開する
final class AgreementViewModel: BaseViewModel<AgreementViewModel>, AgreementViewModelInterface {

    /// Viewからのイベントを受け取りたい変数を定義する
    struct Input: InputType {
        // PublishRelayは初期値がない
        let viewWillAppear = PublishRelay<Void>()
        let didTapTermsButton = PublishRelay<Void>()
        let didTapPrivacyButton = PublishRelay<Void>()
        let didTapAgreementButton = PublishRelay<Void>()
    }

    /// Viewに購読させたい変数を定義する
    struct Output: OutputType {
        // Observableは値を流すことができない購読専用 (ViewからOutputに値を流せなくする)
    }

    /// 状態変数を定義する(MVVMでいうModel相当)
    struct State: StateType {
        // BehaviorRelayは初期値があり､現在の値を保持することができる｡
    }

    /// Presentationレイヤーより上の依存物(APIやUseCase)や引数を定義する
    struct Dependency: DependencyType {
        let router: AgreementRouterInterface
    }

    /// Input, Stateからプレゼンテーションロジックを実装し､Outputにイベントを流す｡
    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {

        input.didTapTermsButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe { _ in
                dependency.router.navigate(.goWeb(Url.termsOfService.urlRequest()))
            }
            .disposed(by: disposeBag)

        input.didTapPrivacyButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe { _ in
                dependency.router.navigate(.goWeb(Url.privacyPolicy.urlRequest()))
            }
            .disposed(by: disposeBag)

        input.didTapAgreementButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe { _ in
                dependency.router.navigate(.agree)
            }
            .disposed(by: disposeBag)

        return .init(
        )
    }
}
