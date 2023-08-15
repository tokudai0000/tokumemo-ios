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
        let viewDidLoad = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let viewWillDisappear = PublishRelay<Void>()
        let urlPendingLoad = PublishRelay<URL>()
        let urlDidLoad = PublishRelay<URL>()
    }

    struct Output: OutputType {
        let loadUrl: Observable<URLRequest>
        let statusLabel: Observable<String>
        let reloadLoginURLInWebView: Observable<Void>
        let loginJavaScriptInjection: Observable<(cAccount: String, password: String)>
        let activityIndicator: Observable<Bool>
    }

    struct State: StateType {
        let canExecuteJavascript: BehaviorRelay<Bool?> = .init(value: nil)
        let termVersion: BehaviorRelay<String?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: SplashRouterInterface
        let initSettingsAPI: InitSettingsAPIInterface
        let passwordStoreUseCase: PasswordStoreUseCaseInterface
        let initSettingsStoreUseCase: InitSettingsStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let loadUrl: PublishRelay<URLRequest> = .init()
        let statusLabel: PublishRelay<String> = .init()
        let reloadLoginURLInWebView: PublishRelay<Void> = .init()
        let loginJavaScriptInjection: PublishRelay<(cAccount: String, password: String)> = .init()
        let activityIndicator: PublishRelay<Bool> = .init()

        func shouldInjectJavaScript(at urlString: String) -> Bool {
            if state.canExecuteJavascript.value == false { return false }
            if urlString.contains(Url.universityLogin.string()) { return true }
            return false
        }

        /// タイムアウトのURLであるか判定
        func isUniversityServiceTimeoutURL(_ urlStr: String) -> Bool {
            return urlStr == Url.universityServiceTimeOut.string() || urlStr == Url.universityServiceTimeOut2.string()
        }

        /// ログインが完了した直後のURLであるか
        /// ログイン画面から、ログイン完了後に遷移される画面は3種類
        /// 1, アンケート最速画面
        /// 2, 教務事務システムのモバイル画面(iPhone)
        /// 3, 教務事務システムのPC画面(iPad)
        func isURLImmediatelyAfterLogin(_ urlStr: String) -> Bool {
            let targetURLs = [Url.skipReminder.string(),
                              Url.courseManagementMobile.string(),
                              Url.courseManagementPC.string()]

            for target in targetURLs {
                if urlStr == target {
                    return true
                }
            }
            return false
        }

        func isTermsVersionDifferent(current: String, accepted: String) -> Bool {
            return current != accepted
        }

        func getInitSettings() {
            dependency.initSettingsAPI.getInitSettings()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        state.termVersion.accept(response.currentTermVersion)

                        dependency.initSettingsStoreUseCase.assignmentNumberOfUsers(response.numberOfUsers)
                        dependency.initSettingsStoreUseCase.assignmentTermText(response.termText)

                        let current = response.currentTermVersion
                        let accepted = dependency.initSettingsStoreUseCase.fetchAcceptedTermVersion()
                        if isTermsVersionDifferent(current: current, accepted: accepted) {
                            // メインスレッドで実行
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                dependency.router.navigate(.agree(current))
                            }
                            return
                        }

                        statusLabel.accept(R.string.localizable.processing_login())

                    },
                    onFailure: { error in
                        AKLog(level: .ERROR, message: error)
                    }
                )
                .disposed(by: disposeBag)
        }

        input.viewDidLoad
            .subscribe { _ in
                loadUrl.accept(Url.universityTransitionLogin.urlRequest())
                getInitSettings()
            }
            .disposed(by: disposeBag)

        input.viewWillAppear
            .subscribe { _ in
                activityIndicator.accept(true)
                statusLabel.accept(R.string.localizable.verifying_authentication())

                // ログイン処理に失敗した場合、10秒後には必ずメイン画面に遷移
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    dependency.router.navigate(.main)
                }
                return
            }
            .disposed(by: disposeBag)

        input.viewWillDisappear
            .subscribe { _ in
                activityIndicator.accept(false)
            }
            .disposed(by: disposeBag)


        input.urlPendingLoad
            .subscribe { url in
                guard let url = url.element else{ return }
                let urlStr = url.absoluteString

                if isUniversityServiceTimeoutURL(urlStr) {
                    reloadLoginURLInWebView.accept(Void())
                }

//                if isURLImmediatelyAfterLogin(urlStr) {
//                    dependency.router.navigate(.main)
//                }
            }
            .disposed(by: disposeBag)

        input.urlDidLoad
            .subscribe { url in
                guard let url = url.element else{ return }
                let urlStr = url.absoluteString

                if shouldInjectJavaScript(at: urlStr) {
                    let cAccount = dependency.passwordStoreUseCase.fetchCAccount()
                    let password = dependency.passwordStoreUseCase.fetchPassword()
                    loginJavaScriptInjection.accept((cAccount: cAccount, password: password))
                    state.canExecuteJavascript.accept(false)
                }
            }
            .disposed(by: disposeBag)

        return .init(
            loadUrl: loadUrl.asObservable(),
            statusLabel: statusLabel.asObservable(),
            reloadLoginURLInWebView: reloadLoginURLInWebView.asObservable(),
            loginJavaScriptInjection: loginJavaScriptInjection.asObservable(),
            activityIndicator: activityIndicator.asObservable()
        )
    }
}
