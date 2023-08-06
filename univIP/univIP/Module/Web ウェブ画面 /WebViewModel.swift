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

/// ViewからのInputに応じで処理を行いOutputとして公開する
final class WebViewModel: BaseViewModel<WebViewModel>, WebViewModelInterface {
    /// JavaScriptを動かす種類
    enum JavaScriptInjectionType {
        case skipReminder // アンケート解答の催促画面
        case syllabus // シラバスの検索画面
        case loginIAS // 大学統合認証システム(IAS)のログイン画面
        case loginOutlook // メール(Outlook)のログイン画面
        case loginCareerCenter // 徳島大学キャリアセンターのログイン画面
        case none // JavaScriptを動かす必要がない場合
    }

    /// Viewからのイベントを受け取りたい変数を定義する
    struct Input: InputType {
        // PublishRelayは初期値がない
        let viewDidAppear = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let didTapSafariButton = PublishRelay<Void>()
        let loadingUrl = PublishRelay<URLRequest>()
    }

    /// Viewに購読させたい変数を定義する
    struct Output: OutputType {
        // Observableは値を流すことができない購読専用 (ViewからOutputに値を流せなくする)
        let loadUrl: Observable<URLRequest>
        let openSafari: Observable<URLRequest>
        let javaScriptInjectionType: Observable<JavaScriptInjectionType>

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
    }

    /// Input, Stateからプレゼンテーションロジックを実装し､Outputにイベントを流す｡
    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let loadUrl: PublishRelay<URLRequest> = .init()
        let openSafari: PublishRelay<URLRequest> = .init()
        let javaScriptInjectionType: PublishRelay<JavaScriptInjectionType> = .init()

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

        input.loadingUrl
            .subscribe { url in
//                state.displayUrl.accept(url)
//                loadUrl.accept(url)
//                if let type = anyJavaScriptExecute(state: state) {
//                    javaScriptInjectionType.accept(type)
//                }
            }
            .disposed(by: disposeBag)

        return .init(
            loadUrl: loadUrl.asObservable(),
            openSafari: openSafari.asObservable(),
            javaScriptInjectionType: javaScriptInjectionType.asObservable()
        )

        func anyJavaScriptExecute(state: State) -> JavaScriptInjectionType? {
            guard let canExecuteJS = state.canExecuteJavascript.value,
                  let urlString = state.displayUrl.value?.description else { return nil }
            // JavaScriptを実行するフラグが立っていない場合はnoneを返す
            if canExecuteJS == false {
                return nil
            }
            // アンケート解答の催促画面
            if urlString == Url.skipReminder.string() {
                return .skipReminder
            }
            // 大学統合認証システム(IAS)のログイン画面
            if urlString.contains(Url.universityLogin.string()) {
                return .loginIAS
            }
            // シラバスの検索画面
            if urlString == Url.syllabus.string() {
                return .syllabus
            }
            // メール(Outlook)のログイン画面
            if urlString.contains(Url.outlookLoginForm.string()) {
                return .loginOutlook
            }
            // 徳島大学キャリアセンターのログイン画面
            if urlString == Url.tokudaiCareerCenter.string() {
                return .loginCareerCenter
            }
            // それ以外なら
            return nil
        }
    }
}


//final class WebViewModel {
//    // Safariで開く用として、現在表示しているURLを保存する
//    public var loadingUrlStr = "https://www.google.com/?hl=ja"
//
//    private let dataManager = DataManager.singleton
//
//    private let safariUrls = ["https://teams.microsoft.com/l/meetup-join", "https://zoom.us/meeting/register/","https://join.skype.com/"]
//
//    /// タイムアウトのURLであるか判定
//    public func isTimeout(urlStr: String) -> Bool {
//        return urlStr == Url.universityServiceTimeOut.string() || urlStr == Url.universityServiceTimeOut2.string()
//    }
//
//    /// Safariで開きたいURLであるか判定
//    public func shouldOpenSafari(urlStr: String) -> Bool {
//        for url in safariUrls {
//            if urlStr.contains(url) {
//                return true
//            }
//        }
//        return false
//    }
//
//    /// JavaScriptを動かす種類
//    enum JavaScriptType {
//        case skipReminder // アンケート解答の催促画面
//        case syllabus // シラバスの検索画面
//        case loginIAS // 大学統合認証システム(IAS)のログイン画面
//        case loginOutlook // メール(Outlook)のログイン画面
//        case loginCareerCenter // 徳島大学キャリアセンターのログイン画面
//        case none // JavaScriptを動かす必要がない場合
//    }
//    /// JavaScriptを動かしたい指定のURLかどうかを判定し、動かすJavaScriptの種類を返す
//    ///
//    /// - Note: canExecuteJavascriptが重要な理由
//    ///   ログインに失敗した場合に再度ログインのURLが表示されることになる。
//    ///   canExecuteJavascriptが存在しないと、再度ログインの為にJavaScriptが実行され続け無限ループとなってしまう。
//    public func anyJavaScriptExecute(_ urlString: String) -> JavaScriptType {
//        // JavaScriptを実行するフラグが立っていない場合はnoneを返す
//        if dataManager.canExecuteJavascript == false {
//            return .none
//        }
//        // アンケート解答の催促画面
//        if urlString == Url.skipReminder.string() {
//            return .skipReminder
//        }
//        // 大学統合認証システム(IAS)のログイン画面
//        if urlString.contains(Url.universityLogin.string()) {
//            return .loginIAS
//        }
//        // シラバスの検索画面
//        if urlString == Url.syllabus.string() {
//            return .syllabus
//        }
//        // メール(Outlook)のログイン画面
//        if urlString.contains(Url.outlookLoginForm.string()) {
//            return .loginOutlook
//        }
//        // 徳島大学キャリアセンターのログイン画面
//        if urlString == Url.tokudaiCareerCenter.string() {
//            return .loginCareerCenter
//        }
//        // それ以外なら
//        return .none
//    }
//}
