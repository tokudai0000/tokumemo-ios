//
//  InputRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import UIKit

enum InputNavigationDestination {
    case helpmessageAgree
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
                              univAuthStoreUseCase: UnivAuthStoreUseCase(
                                univAuthRepository: UnivAuthOnKeyChainRepository()
                              )
                             )
        )
    }

    func navigate(_ destination: InputNavigationDestination) {
        switch destination {
        case .helpmessageAgree:
            push(HelpmessageAgreeRouter())
        case .back:
            moduleViewController.navigationController?.popViewController(animated: true)
        }
    }
}
