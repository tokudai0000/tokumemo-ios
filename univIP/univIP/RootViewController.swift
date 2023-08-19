//
//  RootViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/05.
//

import UIKit

final class RootViewController: UIViewController {
    private let containerView: UIView = .init()
    private var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        switchToSplash()
    }

    private func setupContainerView() {
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
        if let previousViewController = self.currentViewController {
            previousViewController.willMove(toParent: nil)
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParent()
        }

        addChild(viewController)

        containerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        viewController.didMove(toParent: self)
        self.currentViewController = viewController
        view.layoutSubviews()
    }
}
