//
//  AgreementViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/04.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol AgreementViewModelInterface: AnyObject {
    var input: AgreementViewModel.Input { get }
    var output: AgreementViewModel.Output { get }
}

final class AgreementViewModel: BaseViewModel<AgreementViewModel>, AgreementViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let didTapTermsButton = PublishRelay<Void>()
        let didTapPrivacyButton = PublishRelay<Void>()
        let didTapAgreementButton = PublishRelay<Void>()
    }

    struct Output: OutputType {
        let termText: Observable<String>
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: AgreementRouterInterface
        let currentTermVersion: String
        let initSettingsStoreUseCase: InitSettingsStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let termText: PublishRelay<String> = .init()

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // ユーザーの操作を阻害しない
            .subscribe(onNext: { _ in
                termText.accept(dependency.initSettingsStoreUseCase.fetchTermText())
            })
            .disposed(by: disposeBag)

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
                dependency.initSettingsStoreUseCase.assignmentAcceptedTermVersion(dependency.currentTermVersion)
                dependency.router.navigate(.agree)
            }
            .disposed(by: disposeBag)

        return .init(
            termText: termText.asObservable()
        )
    }
}
