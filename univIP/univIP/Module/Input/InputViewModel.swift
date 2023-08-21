//
//  InputViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol InputViewModelInterface: AnyObject {
    var input: InputViewModel.Input { get }
    var output: InputViewModel.Output { get }
}

final class InputViewModel: BaseViewModel<InputViewModel>, InputViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let didTapBackButton = PublishRelay<Void>()
        let didTapResetOKButton = PublishRelay<Void>()
        let didTapSaveButton = PublishRelay<(cAccount: String?, password: String?)>()
        let didHelpmessageAgreeButton = PublishRelay<Void>()
    }

    struct Output: OutputType {
        let textField1: Observable<String>
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: InputRouterInterface
        let univAuthStoreUseCase: UnivAuthStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let textField1: PublishRelay<String> = .init()

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // ユーザーの操作を阻害しない
            .subscribe(onNext: { _ in
                textField1.accept(dependency.univAuthStoreUseCase.fetchUnivAuth().accountCID)
            })
            .disposed(by: disposeBag)

        input.didTapBackButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.router.navigate(.back)
            })
            .disposed(by: disposeBag)

        input.didTapResetOKButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.univAuthStoreUseCase.setUnivAuth(UnivAuth(accountCID: "", password: ""))
            })
            .disposed(by: disposeBag)


        input.didTapSaveButton
            .subscribe { items in
                if let items = items.element,
                let cAccount = items.cAccount,
                   let password = items.password{
                    dependency.univAuthStoreUseCase.setUnivAuth(
                        UnivAuth(accountCID: cAccount.description, password: password.description)
                    )
//                    alert(title: "♪ 登録完了 ♪",
//                          message: "以降、アプリを開くたびに自動ログインの機能が使用できる様になりました。")
                    //
                    //                default:
                    //                    fatalError()
                    //                }
                }
            }
            .disposed(by: disposeBag)

        input.didHelpmessageAgreeButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.router.navigate(.helpmessageAgree)
            })
            .disposed(by: disposeBag)

        return .init(
            textField1: textField1.asObservable()
        )
    }
}
