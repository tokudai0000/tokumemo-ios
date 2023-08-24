//
//  SplashViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import UIKit
import WebKit
import RxSwift
import Entity

final class SplashViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var statusLabel: UILabel!

    // バックグラウンドでログインの処理を行う
    private var webView: WKWebView = .init(frame: .zero)

    private let disposeBag = DisposeBag()
    
    var viewModel: SplashViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefault()
        configureWebView()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.accept(())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.input.viewWillDisappear.accept(())
    }
}

// MARK: Binding
private extension SplashViewController {
    func binding() {

        viewModel.output
            .loadUrl
            .asDriver(onErrorJustReturn: Url.emptyRequest.urlRequest())
            .drive(with: self) { owner, urlRequest in
                owner.webView.load(urlRequest)
            }
            .disposed(by: disposeBag)
        
        viewModel.output
            .statusLabel
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.statusLabel.text = text
            }
            .disposed(by: disposeBag)

        viewModel.output
            .activityIndicator
            .asDriver(onErrorJustReturn: .stop)
            .drive(with: self) { owner, state in
                switch state {
                case .start:
                    owner.activityIndicator?.startAnimating()
                case .stop:
                    owner.activityIndicator?.stopAnimating()
                }
            }
            .disposed(by: disposeBag)

        viewModel.output
            .reloadLoginURLInWebView
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.webView.load(Url.universityTransitionLogin.urlRequest())
            }
            .disposed(by: disposeBag)

        viewModel.output
            .loginJavaScriptInjection
            .asDriver(onErrorJustReturn: UnivAuth(accountCID: "", password: ""))
            .drive(with: self) { owner, univAuth in
                owner.webView.evaluateJavaScript("document.getElementById('username').value= '\(univAuth.accountCID)'", completionHandler:  nil)
                owner.webView.evaluateJavaScript("document.getElementById('password').value= '\(univAuth.password)'", completionHandler:  nil)
                owner.webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension SplashViewController {
    func configureDefault() {
        statusLabel.text = R.string.localizable.verifying_authentication()
    }

    // WebViewは画面には表示させず、裏でログインの処理を実行
    func configureWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.load(Url.universityTransitionLogin.urlRequest())

        // 開発時は、Splash画面の上部に表示
        #if DEBUG || STUB
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        #endif
    }
}

extension SplashViewController: WKNavigationDelegate {
    // リクエスト前
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        viewModel.input.urlPendingLoad.accept(url)
        decisionHandler(.allow)
    }

    // レスポンス取得後
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    // 読み込み完了後
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = self.webView.url{
            viewModel.input.urlDidLoad.accept(url)
        }
    }
}
