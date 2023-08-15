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
        let didTapSaveButton = PublishRelay<(cAccount: String?, password: String?)>()
    }

    struct Output: OutputType {
        let configureTextType: Observable<InputDisplayItem.type>
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: InputRouterInterface
        let type: InputDisplayItem.type
        let passwordStoreUseCase: PasswordStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let configureTextType: PublishRelay<InputDisplayItem.type> = .init()

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // ユーザーの操作を阻害しない
            .subscribe(onNext: { _ in
                configureTextType.accept(dependency.type)
                print(dependency.passwordStoreUseCase.fetchCAccount())
                print(dependency.passwordStoreUseCase.fetchPassword())
            })
            .disposed(by: disposeBag)

        input.didTapBackButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.router.navigate(.back)
            })
            .disposed(by: disposeBag)

        input.didTapSaveButton
            .subscribe { items in
                if let items = items.element,
                let cAccount = items.cAccount,
                   let password = items.password{
                    dependency.passwordStoreUseCase.assignmentCAccount(cAccount.description)
                    dependency.passwordStoreUseCase.assignmentPassword(password.description)

                    //                if type == .syllabus {
                    //                    dataManager.syllabusTeacherName = text1
                    //                    dataManager.syllabusSubjectName = text2
                    //                    let vc = R.storyboard.web.webViewController()!
                    //                    vc.loadUrlString = Url.syllabus.string()
                    //                    present(vc, animated: true, completion: nil)
                    //                    return
                    //                }
                    //
                    //                if text1.isEmpty {
                    //                    MessageLabel1.text = "空欄です"
                    //                    textFieldCursorSetup(fieldType: .one, cursorType: .error)
                    //                    return
                    //                }
                    //
                    //                if text2.isEmpty {
                    //                    MessageLabel2.text = "空欄です"
                    //                    textFieldCursorSetup(fieldType: .two, cursorType: .error)
                    //                    return
                    //                }
                    //
                    //                if type == .password, text1.prefix(1) != "c" {
                    //                    MessageLabel1.text = "cアカウントを入力してください"
                    //                    textFieldCursorSetup(fieldType: .one, cursorType: .error)
                    //                    return
                    //                }
                    //
                    //                // エラー表示が出ていた場合、画面を初期化
                    //                initSetup(type)
                    //
                    //                switch type {
                    //                case .password:
                    //                    // 再ログインをする
                    //                    dataManager.shouldRelogin = true
                    //                    // KeyChianに保存する
                    //                    dataManager.cAccount = text1
                    //                    dataManager.password = text2
                    //                    initSetup(.password)
                    //                    dataManager.loginState.completed = false
                    //                    alert(title: "♪ 登録完了 ♪",
                    //                          message: "以降、アプリを開くたびに自動ログインの機能が使用できる様になりました。")
                    //
                    //                default:
                    //                    fatalError()
                    //                }
                }
            }
            .disposed(by: disposeBag)

        return .init(
            configureTextType: configureTextType.asObservable()
        )
    }
}
