//
//  SplashViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

final class SplashViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var statusLabel: UILabel!

    private var webView: WKWebView = .init(frame: .zero)
    private let disposeBag = DisposeBag()

    var viewModel: SplashViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaults()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.input.viewWillAppear.accept(())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        viewModel.input.viewWillDisappear.accept(())
    }
}

// MARK: Binding
private extension SplashViewController {
    func binding() {

        viewModel.output
            .statusLabel
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.statusLabel.text = text
            }
            .disposed(by: disposeBag)

        viewModel.output
            .loadUrl
            .asDriver(onErrorJustReturn: Url.privacyPolicy.urlRequest())
            .drive(with: self) { owner, urlRequest in
                owner.webView.load(urlRequest)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .activityIndicator
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, flag in
                if let activityIndicator = owner.activityIndicator {
                    if flag {
                        activityIndicator.startAnimating()
                    } else {
                        activityIndicator.stopAnimating()
                    }
                }
            }
            .disposed(by: disposeBag)

        viewModel.output
            .loginJavaScriptInjection
            .asDriver(onErrorJustReturn: (cAccount: "", password: ""))
            .drive(with: self) { owner, data in
                owner.webView.evaluateJavaScript("document.getElementById('username').value= '\(data.cAccount)'", completionHandler:  nil)
                owner.webView.evaluateJavaScript("document.getElementById('password').value= '\(data.password)'", completionHandler:  nil)
                owner.webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension SplashViewController {
    func configureDefaults() {
        webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(Url.universityTransitionLogin.urlRequest())
    }
}

extension SplashViewController: WKUIDelegate, WKNavigationDelegate {
    // 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            AKLog(level: .FATAL, message: "読み込み前のURLがnil")
            decisionHandler(.cancel)
            return
        }
        viewModel.input.urlPendingLoad.accept(url)
        decisionHandler(.allow)
    }

    // 読み込み設定（レスポンス取得後）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = self.webView.url{
            viewModel.input.urlDidLoad.accept(url)
        }
    }
}
