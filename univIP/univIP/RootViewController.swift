//
//  RootViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/05.
//

import UIKit

final class RootViewController: UIViewController {
    private let containerView: UIView = .init()
    private var currentChildViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        switchToSplash()
    }

    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func switchToSplash() {
        let navigationController = SplashRouter().moduleViewController
        switchContainer(to: navigationController)
    }

    func switchToAgreement(currentTermVersion: String) {
        let navigationController = AgreementRouter(currentTermVersion: currentTermVersion).moduleViewController
        switchContainer(to: navigationController)
    }

    func switchToMain() {
        let navigationController = MainRouter().moduleViewController
        switchContainer(to: navigationController)
    }

    private func switchContainer(to viewController: UIViewController) {
        // 現在の子ViewControllerを削除
        if let previousViewController = self.currentChildViewController {
            previousViewController.willMove(toParent: nil)
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParent()
        }
        // 新しい子ViewControllerのViewをcontainerViewに追加
        self.currentChildViewController = viewController
        containerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        // RootViewControllerに子ViewControllerを追加
        addChild(viewController)
        viewController.didMove(toParent: self)

        view.layoutSubviews()
    }
}
