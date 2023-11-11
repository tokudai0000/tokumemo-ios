//
//  HelpmessageAgreeViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/20.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift
import Features

protocol HelpmessageAgreeViewModelInterface: AnyObject {
    var input: HelpmessageAgreeViewModel.Input { get }
    var output: HelpmessageAgreeViewModel.Output { get }
}

final class HelpmessageAgreeViewModel: BaseViewModel<HelpmessageAgreeViewModel>, HelpmessageAgreeViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let didTapBackButton = PublishRelay<Void>()
    }

    struct Output: OutputType {
        let textView: Observable<String>
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: HelpmessageAgreeRouterInterface
        let helpmessageAgreeAPI: HelpmessegeAgreeAPIInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let textView: PublishRelay<String> = .init()

        func getAgreementText() {
            dependency.helpmessageAgreeAPI.getHelpmessegeAgree()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        textView.accept(response.helpmessageAgreeText)
                    },
                    onFailure: { error in
                        textView.accept("読み込みに失敗しました")
//                        AKLog(level: .ERROR, message: error)
                    }
                )
                .disposed(by: disposeBag)
        }

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(onNext: { _ in
                getAgreementText()
            })
            .disposed(by: disposeBag)

        input.didTapBackButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.router.navigate(.back)
            })
            .disposed(by: disposeBag)

        return .init(
            textView: textView.asObservable()
        )
    }
}
