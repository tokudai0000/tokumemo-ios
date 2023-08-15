//
//  webViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/17.
//

import Foundation
import RxRelay
import RxSwift

protocol WebViewModelInterface: AnyObject {
    var input: WebViewModel.Input { get }
    var output: WebViewModel.Output { get }
}

final class WebViewModel: BaseViewModel<WebViewModel>, WebViewModelInterface {

    struct Input: InputType {
        let viewDidAppear = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let didTapSafariButton = PublishRelay<Void>()
        let urlPendingLoad = PublishRelay<URL>()
        let urlDidLoad = PublishRelay<URL>()
    }

    struct Output: OutputType {
        let loadUrl: Observable<URLRequest>
        let reloadLoginURLInWebView: Observable<Void>
        let urlLabel: Observable<String>
        let openSafari: Observable<URLRequest>
        let loginJavaScriptInjection: Observable<(cAccount: String, password: String)>
        let loginOutlookJavaScriptInjection: Observable<(cAccount: String, password: String)>
        let loginCareerCenterJavaScriptInjection: Observable<(cAccount: String, password: String)>
    }

    /// 状態変数を定義する(MVVMでいうModel相当)
    struct State: StateType {
        // BehaviorRelayは初期値があり､現在の値を保持することができる｡
        let displayUrl: BehaviorRelay<URLRequest?> = .init(value: nil)
        let canExecuteJavascript: BehaviorRelay<Bool?> = .init(value: nil)
    }

    /// Presentationレイヤーより上の依存物(APIやUseCase)や引数を定義する
    struct Dependency: DependencyType {
        let router: WebRouterInterface
        let loadUrl: URLRequest
        let passwordStoreUseCase: PasswordStoreUseCaseInterface
    }

    /// Input, Stateからプレゼンテーションロジックを実装し､Outputにイベントを流す｡
    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let loadUrl: PublishRelay<URLRequest> = .init()
        let reloadLoginURLInWebView: PublishRelay<Void> = .init()
        let urlLabel: PublishRelay<String> = .init()
        let openSafari: PublishRelay<URLRequest> = .init()
        let loginJavaScriptInjection: PublishRelay<(cAccount: String, password: String)> = .init()
        let loginOutlookJavaScriptInjection: PublishRelay<(cAccount: String, password: String)> = .init()
        let loginCareerCenterJavaScriptInjection: PublishRelay<(cAccount: String, password: String)> = .init()

        func shouldInjectJavaScript(at urlString: String) -> Bool {
            if state.canExecuteJavascript.value == false { return false }
            if urlString.contains(Url.universityLogin.string()) { return true }
            return false
        }

        func shouldOutlookInjectJavaScript(at urlString: String) -> Bool {
            if state.canExecuteJavascript.value == false { return false }
            if urlString.contains(Url.outlookLoginForm.string()) { return true }
            return false
        }

        func shouldCareerCenterInjectJavaScript(at urlString: String) -> Bool {
            if state.canExecuteJavascript.value == false { return false }
            if urlString.contains(Url.tokudaiCareerCenter.string()) { return true }
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
        
        input.viewDidAppear
            .subscribe { _ in
                let url = dependency.loadUrl
                state.displayUrl.accept(url)
                loadUrl.accept(url)
            }
            .disposed(by: disposeBag)

        input.viewWillAppear
            .subscribe { _ in
            }
            .disposed(by: disposeBag)

        input.didTapSafariButton
            .subscribe { _ in
                if let url = state.displayUrl.value {
                    openSafari.accept(url)
                }
            }
            .disposed(by: disposeBag)

        input.urlPendingLoad
            .subscribe { url in
                guard let url = url.element else{ return }
                let urlStr = url.absoluteString

                if isUniversityServiceTimeoutURL(urlStr) {
                    reloadLoginURLInWebView.accept(Void())
                }
            }
            .disposed(by: disposeBag)

        input.urlDidLoad
            .subscribe { url in
                guard let url = url.element,
                      let host = url.host else{ return }
                let urlStr = url.absoluteString

                urlLabel.accept(host.description)

                if shouldInjectJavaScript(at: urlStr) {
                    let cAccount = dependency.passwordStoreUseCase.fetchCAccount()
                    let password = dependency.passwordStoreUseCase.fetchPassword()
                    loginJavaScriptInjection.accept((cAccount: cAccount, password: password))
                    state.canExecuteJavascript.accept(false)
                }

                if shouldOutlookInjectJavaScript(at: urlStr) {
                    let cAccount = dependency.passwordStoreUseCase.fetchCAccount()
                    let password = dependency.passwordStoreUseCase.fetchPassword()
                    loginOutlookJavaScriptInjection.accept((cAccount: cAccount, password: password))
                    state.canExecuteJavascript.accept(false)
                }

                if shouldCareerCenterInjectJavaScript(at: urlStr) {
                    let cAccount = dependency.passwordStoreUseCase.fetchCAccount()
                    let password = dependency.passwordStoreUseCase.fetchPassword()
                    loginCareerCenterJavaScriptInjection.accept((cAccount: cAccount, password: password))
                    state.canExecuteJavascript.accept(false)
                }
            }
            .disposed(by: disposeBag)

        return .init(
            loadUrl: loadUrl.asObservable(),
            reloadLoginURLInWebView: reloadLoginURLInWebView.asObservable(),
            urlLabel: urlLabel.asObservable(),
            openSafari: openSafari.asObservable(),
            loginJavaScriptInjection: loginJavaScriptInjection.asObservable(),
            loginOutlookJavaScriptInjection: loginOutlookJavaScriptInjection.asObservable(),
            loginCareerCenterJavaScriptInjection: loginCareerCenterJavaScriptInjection.asObservable()
        )
    }
}
