//
//  InputRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation
import UIKit

enum InputNavigationDestination {
    case goWeb
    case back
}

protocol InputRouterInterface {
    func navigate(_ destination: InputNavigationDestination)
}

final class InputRouter: BaseRouter, InputRouterInterface {
    init(type: InputDisplayItem.type) {
        let viewController = R.storyboard.input.inputViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = InputViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                             type: type,
                             passwordStoreUseCase: PasswordStoreUseCase(passwordRepository: PasswordOnKeyChainRepository())))
    }

    func navigate(_ destination: InputNavigationDestination) {
        switch destination {
        case .goWeb:
            moduleViewController.navigationController?.popViewController(animated: true)
        case .back:
            moduleViewController.dismiss(animated: true)
        }
    }
}
