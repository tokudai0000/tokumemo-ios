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
        let viewDidLoad = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let viewClose = PublishRelay<Void>()
        let didTapSafariButton = PublishRelay<Void>()
        let didTapMenuButton = PublishRelay<Void>()
        let urlPendingLoad = PublishRelay<URL>()
        let urlDidLoad = PublishRelay<URL>()
    }

    struct Output: OutputType {
        let loadUrl: Observable<URLRequest>
        let reloadLoginURLInWebView: Observable<Void>
        let urlLabel: Observable<String>
        let openSafari: Observable<URLRequest>
        let skipReminderJavaScriptInjection: Observable<Void>
        let loginJavaScriptInjection: Observable<UnivAuth>
        let loginOutlookJavaScriptInjection: Observable<UnivAuth>
        let loginCareerCenterJavaScriptInjection: Observable<UnivAuth>
    }

    struct State: StateType {
        let displayUrl: BehaviorRelay<URLRequest?> = .init(value: nil)
        let canExecuteJavascript: BehaviorRelay<Bool?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: WebRouterInterface
        let loadUrl: URLRequest
        let univAuthStoreUseCase: UnivAuthStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let loadUrl: PublishRelay<URLRequest> = .init()
        let reloadLoginURLInWebView: PublishRelay<Void> = .init()
        let urlLabel: PublishRelay<String> = .init()
        let openSafari: PublishRelay<URLRequest> = .init()
        let skipReminderJavaScriptInjection: PublishRelay<Void> = .init()
        let loginJavaScriptInjection: PublishRelay<UnivAuth> = .init()
        let loginOutlookJavaScriptInjection: PublishRelay<UnivAuth> = .init()
        let loginCareerCenterJavaScriptInjection: PublishRelay<UnivAuth> = .init()

        input.viewDidLoad
            .subscribe { _ in
                let url = dependency.loadUrl
                state.displayUrl.accept(url)

                if url == Url.review.urlRequest() {
                    openSafari.accept(url)
                }else{
                    loadUrl.accept(url)
                }
            }
            .disposed(by: disposeBag)

        input.viewWillAppear
            .subscribe { _ in
                state.canExecuteJavascript.accept(true)
            }
            .disposed(by: disposeBag)

        input.viewClose
            .subscribe { _ in
                dependency.router.navigate(.close)
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
                guard let url = url.element,
                      let host = url.host else {
                    return
                }
                urlLabel.accept(host.description)

                if URLCheckers.isUniversityServiceTimeoutURL(at: url.absoluteString) {
                    reloadLoginURLInWebView.accept(Void())
                }
            }
            .disposed(by: disposeBag)

        input.urlDidLoad
            .subscribe { url in
                guard let url = url.element,
                      let canExecuteJavascript = state.canExecuteJavascript.value else {
                    return
                }

                if URLCheckers.isSkipReminderURL(at: url.absoluteString) {
                    skipReminderJavaScriptInjection.accept(Void())
                }

                if URLCheckers.shouldInjectJavaScript(at: url.absoluteString, canExecuteJavascript, for: .universityLogin) {
                    state.canExecuteJavascript.accept(false)
                    loginJavaScriptInjection.accept(dependency.univAuthStoreUseCase.fetchUnivAuth())
                }

                if URLCheckers.shouldInjectJavaScript(at: url.absoluteString, canExecuteJavascript, for: .outlookLoginForm) {
                    state.canExecuteJavascript.accept(false)
                    loginOutlookJavaScriptInjection.accept(dependency.univAuthStoreUseCase.fetchUnivAuth())
                }

                if URLCheckers.shouldInjectJavaScript(at: url.absoluteString, canExecuteJavascript, for: .tokudaiCareerCenter) {
                    state.canExecuteJavascript.accept(false)
                    loginCareerCenterJavaScriptInjection.accept(dependency.univAuthStoreUseCase.fetchUnivAuth())
                }
            }
            .disposed(by: disposeBag)

        return .init(
            loadUrl: loadUrl.asObservable(),
            reloadLoginURLInWebView: reloadLoginURLInWebView.asObservable(),
            urlLabel: urlLabel.asObservable(),
            openSafari: openSafari.asObservable(),
            skipReminderJavaScriptInjection: skipReminderJavaScriptInjection.asObservable(),
            loginJavaScriptInjection: loginJavaScriptInjection.asObservable(),
            loginOutlookJavaScriptInjection: loginOutlookJavaScriptInjection.asObservable(),
            loginCareerCenterJavaScriptInjection: loginCareerCenterJavaScriptInjection.asObservable()
        )
    }
}
