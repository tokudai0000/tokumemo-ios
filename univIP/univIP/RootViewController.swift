//
//  RootViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/05.
//

import UIKit
import NorthLayout

final class RootViewController: UIViewController {
    private let containerView: UIView = .init()
    private var currentChildViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        switchToSplash()
    }

    func switchToSplash() {
        let navigationController = SplashRouter().moduleViewController
        switchContainer(to: navigationController)
    }

    func switchToAgreement(_ currentVersion: String) {
        let navigationController = AgreementRouter(currentVersion: currentVersion).moduleViewController
        switchContainer(to: navigationController)
    }

    func switchToMain() {
        let navigationController = MainRouter().moduleViewController
        switchContainer(to: navigationController)
    }

    private func configureContainerView() {
        let autolayout = view.northLayoutFormat([:], [
            "container": containerView
        ])
        autolayout("H:|[container]|")
        autolayout("V:|[container]|")
    }

    private func switchContainer(to viewController: UIViewController) {
        // 現在の子ViewControllerを削除
        if let previousViewController = self.currentChildViewController {
            previousViewController.willMove(toParent: nil)
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParent()
        }
        // 新しい子ViewControllerのViewをcontainerViewに追加
        let autolayout = containerView.northLayoutFormat([:], [
            "viewController": viewController.view
        ])
        autolayout("H:|[viewController]|")
        autolayout("V:|[viewController]|")
        self.currentChildViewController = viewController
        // RootViewControllerに子ViewControllerを追加
        addChild(viewController)
        viewController.didMove(toParent: self)
        view.layoutSubviews()
    }
}
