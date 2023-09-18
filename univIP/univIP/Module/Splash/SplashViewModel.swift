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
import API
import Entity

protocol SplashViewModelInterface: AnyObject {
    var input: SplashViewModel.Input { get }
    var output: SplashViewModel.Output { get }
}

final class SplashViewModel: BaseViewModel<SplashViewModel>, SplashViewModelInterface {

    enum ActivityIndicatorState {
        case start
        case stop
    }

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let viewWillDisappear = PublishRelay<Void>()
        let urlPendingLoad = PublishRelay<URL>()
        let urlDidLoad = PublishRelay<URL>()
    }

    struct Output: OutputType {
        let loadUrl: Observable<URLRequest>
        let statusLabel: Observable<String>
        let activityIndicator: Observable<ActivityIndicatorState>
        let reloadLoginURLInWebView: Observable<Void>
        let loginJavaScriptInjection: Observable<UnivAuth>
    }

    struct State: StateType {
        let termVersion: BehaviorRelay<String?> = .init(value: nil)
        let canExecuteJavascript: BehaviorRelay<Bool?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: SplashRouterInterface
        let currentTermVersionAPI: CurrentTermVersionAPI
        let univAuthStoreUseCase: UnivAuthStoreUseCaseInterface
        let acceptedTermVersionStoreUseCase: AcceptedTermVersionStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let loadUrl: PublishRelay<URLRequest> = .init()
        let statusLabel: PublishRelay<String> = .init()
        let activityIndicator: PublishRelay<ActivityIndicatorState> = .init()
        let reloadLoginURLInWebView: PublishRelay<Void> = .init()
        let loginJavaScriptInjection: PublishRelay<UnivAuth> = .init()

        func isTermsVersionDifferent(current: String, accepted: String) -> Bool {
            return current != accepted
        }

        func processTermVersion() {
            let current = AppConstants.version.termsOfServiceVersion
            let accepted = dependency.acceptedTermVersionStoreUseCase.fetchAcceptedTermVersion()
            print("akidon-current \(current)")
            print("akidon-accepted \(accepted)")
            if isTermsVersionDifferent(current: current, accepted: accepted) {
                // メインスレッドで実行(即AgreementViewの画面に行かないとWebログイン失敗もしくは成功の判定が先になり、表示されない可能性あり)
                // AgreementVerを判定してからMain画面に飛ばす判定を組み込む予定
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    dependency.router.navigate(.agree)
                }
            } else {
                // 同意済みなのでログイン処理へと進む
                statusLabel.accept(R.string.localizable.processing_login())
                loadUrl.accept(Url.universityTransitionLogin.urlRequest())
            }
        }

        input.viewDidLoad
            .subscribe { _ in
                processTermVersion()
            }
            .disposed(by: disposeBag)

        input.viewWillAppear
            .subscribe { _ in
                state.canExecuteJavascript.accept(true)
                activityIndicator.accept(.start)

                // ログイン処理に失敗した場合、10秒後には必ずメイン画面に遷移
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    dependency.router.navigate(.main)
                }
            }
            .disposed(by: disposeBag)

        input.viewWillDisappear
            .subscribe { _ in
                activityIndicator.accept(.stop)
            }
            .disposed(by: disposeBag)


        input.urlPendingLoad
            .subscribe { url in
                guard let url = url.element else{
                    return
                }
                // タイムアウト
                if URLCheckers.isUniversityServiceTimeoutURL(at: url.absoluteString) {
                    reloadLoginURLInWebView.accept(Void())
                }
                // ログイン成功
                if URLCheckers.isImmediatelyAfterLoginURL(at: url.absoluteString) {
                    dependency.router.navigate(.main)
                }
                // ログイン失敗
                if URLCheckers.isFailureUniversityServiceLoggedInURL(at: url.absoluteString) {
                    dependency.router.navigate(.main)
                }
            }
            .disposed(by: disposeBag)

        input.urlDidLoad
            .subscribe { url in
                guard let url = url.element,
                      let canExecuteJavascript = state.canExecuteJavascript.value else{
                    return
                }
                // ログイン処理を行うURLか判定
                if URLCheckers.shouldInjectJavaScript(at: url.absoluteString, canExecuteJavascript, for: .universityLogin) {
                    state.canExecuteJavascript.accept(false)
                    loginJavaScriptInjection.accept(dependency.univAuthStoreUseCase.fetchUnivAuth())
                }
            }
            .disposed(by: disposeBag)

        return .init(
            loadUrl: loadUrl.asObservable(),
            statusLabel: statusLabel.asObservable(),
            activityIndicator: activityIndicator.asObservable(),
            reloadLoginURLInWebView: reloadLoginURLInWebView.asObservable(),
            loginJavaScriptInjection: loginJavaScriptInjection.asObservable()
        )
    }
}
