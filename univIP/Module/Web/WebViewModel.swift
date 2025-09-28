//
//  webViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/17.
//

import Foundation
import RxRelay
import RxSwift
import AkidonComponents

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
        let showReviewAlert: Observable<Void>
        let changeWebViewZoomLevel: Observable<String>
    }

    struct State: StateType {
        let displayUrl: BehaviorRelay<URLRequest?> = .init(value: nil)
        let canExecuteJavascript: BehaviorRelay<Bool?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: WebRouterInterface
        let loadUrl: URLRequest
        let univAuthStoreUseCase: UnivAuthStoreUseCaseInterface
        let webViewCloseCountStoreUseCase: WebViewCloseCountStoreUseCaseInterface
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
        let showReviewAlert: PublishRelay<Void> = .init()
        let changeWebViewZoomLevel: PublishRelay<String> = .init()

        func updateWebViewCloseCounterAndShowReviewIfNecessary() {
            let counter = dependency.webViewCloseCountStoreUseCase.fetchWebViewCloseCount() + 1
            dependency.webViewCloseCountStoreUseCase.setWebViewCloseCount(counter)
            // 画面が閉じられた回数が累積10回づつでレビューの催促
            // 注: Appleのポリシーにより、レビュー催促が必ず表示されるわけではありません(1年間に表示できるのは3回まで)
            if counter % 10 == 0 {
                showReviewAlert.accept(())
            }
        }

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
                updateWebViewCloseCounterAndShowReviewIfNecessary()
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
                guard let url = url.element else {
                    return
                }

                if URLCheckers.isUniversityServiceTimeoutURL(at: url.absoluteString) {
                    reloadLoginURLInWebView.accept(Void())
                }
            }
            .disposed(by: disposeBag)

        input.urlDidLoad
            .subscribe { url in
                guard let url = url.element,
                      let host = url.host,
                      let canExecuteJavascript = state.canExecuteJavascript.value else {
                    return
                }
                urlLabel.accept(host.description)
                AKLog(level: .DEBUG, message: "urlDidLoad: \(url)")

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

                // 成績一覧から、素点分布のサイトを表示する際、画面全体にグラフが表示されないため、リサイズする。
                if url.absoluteString.contains("SubDetail/Results_Map.aspx") {
                    changeWebViewZoomLevel.accept("0.4")
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
            loginCareerCenterJavaScriptInjection: loginCareerCenterJavaScriptInjection.asObservable(),
            showReviewAlert: showReviewAlert.asObservable(),
            changeWebViewZoomLevel: changeWebViewZoomLevel.asObservable()
        )
    }
}
