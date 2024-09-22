//
//  CreditsRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

import Foundation
import UIKit

enum CreditsNavigationDestination {
    case back
}

protocol CreditsRouterInterface {
    func navigate(_ destination: CreditsNavigationDestination)
}

final class CreditsRouter: BaseRouter, CreditsRouterInterface {
    init() {
        let viewController =  R.storyboard.credits.creditsViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = CreditsViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self)
        )
    }

    func navigate(_ destination: CreditsNavigationDestination) {
        switch destination {
        case .back:
            moduleViewController.navigationController?.popViewController(animated: true)
        }
    }
}
