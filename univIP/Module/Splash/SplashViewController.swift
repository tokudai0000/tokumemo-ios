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
import NorthLayout

final class SplashViewController: UIViewController {
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.icon_memokichi()
        return imageView
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium // `.medium`は適宜、アプリケーションのデザインに合わせて変更してください
        indicator.startAnimating() // 必要に応じてアニメーションを開始
        return indicator
    }()

    private var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.verifying_authentication()
        return label
    }()

    private var copylightLabel: UILabel = {
        let label = UILabel()
        label.text = "Developed by Tokushima Univ Students \n GitHub: @tokudai0000"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = R.color.lightGrayColor()
        return label
    }()

    // バックグラウンドでログインの処理を行う
    private var webView = WKWebView()

    private let disposeBag = DisposeBag()
    
    var viewModel: SplashViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
            .loginStatusLabel
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.loginStatusLabel.text = text
            }
            .disposed(by: disposeBag)

        viewModel.output
            .loadUrl
            .asDriver(onErrorJustReturn: Url.emptyRequest.urlRequest())
            .drive(with: self) { owner, urlRequest in
                owner.webView.load(urlRequest)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .activityIndicator
            .asDriver(onErrorJustReturn: .stop)
            .drive(with: self) { owner, state in
                switch state {
                case .start:
                    owner.activityIndicator.startAnimating()
                case .stop:
                    owner.activityIndicator.stopAnimating()
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
    func configureView() {
        view.backgroundColor = .white

        let autolayout = view.northLayoutFormat([:], [
            "iconImage": iconImageView,
            "activity": activityIndicator,
            "loginStatus": loginStatusLabel,
            "copylight": copylightLabel
        ])
        autolayout("H:|-(>=0)-[iconImage(175)]-(>=0)-|")
        autolayout("H:|-(>=0)-[activity]-(>=0)-|")
        autolayout("H:|-(>=0)-[loginStatus]-(>=0)-|")
        autolayout("H:|-(>=0)-[copylight]-(>=0)-|")
        autolayout("V:|-(>=0)-[iconImage(175)]-10-[activity]-10-[loginStatus]-(>=0)-|")
        autolayout("V:|-(>=0)-[copylight]-15-||")

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            copylightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // WebViewは画面には表示させず、裏でログインの処理を実行
    func configureWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self

        // 開発時は、Splash画面の上部に表示
        #if DEBUG
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
