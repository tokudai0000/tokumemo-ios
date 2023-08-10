//
//  BaseRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/05.
//

import UIKit

class BaseRouter {
    let moduleViewController: UIViewController

    init(moduleViewController: UIViewController) {
        self.moduleViewController = moduleViewController
    }

    func present(_ router: BaseRouter, completion: (() -> Void)? = nil) {
        let viewController = router.moduleViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        moduleViewController.present(viewController, animated: true, completion: completion)
    }

    func modal(_ router: BaseRouter, completion: (() -> Void)? = nil) {
        let viewController = router.moduleViewController
        viewController.modalPresentationStyle = .automatic
        viewController.modalTransitionStyle = .coverVertical
        moduleViewController.present(viewController, animated: true, completion: completion)
    }

    func presentNavigation(_ router: BaseRouter, completion: (() -> Void)? = nil) {
        let viewController = UINavigationController(rootViewController: router.moduleViewController)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        moduleViewController.present(viewController, animated: true, completion: completion)
    }

    func push(_ router: BaseRouter) {
        guard let navigationController = moduleViewController.navigationController else {
            assertionFailure("NavigationController is not set.")
            return
        }
        navigationController.pushViewController(router.moduleViewController, animated: true)
    }
}
