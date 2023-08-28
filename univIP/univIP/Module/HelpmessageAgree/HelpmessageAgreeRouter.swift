//
//  HelpmessageAgreeRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/20.
//

import UIKit
import API
import Core

enum HelpmessageAgreeNavigationDestination {
    case back
}

protocol HelpmessageAgreeRouterInterface {
    func navigate(_ destination: HelpmessageAgreeNavigationDestination)
}

final class HelpmessageAgreeRouter: BaseRouter, HelpmessageAgreeRouterInterface {

    init() {
        let viewController = R.storyboard.helpmessageAgree.helpmessageAgreeViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = HelpmessageAgreeViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              helpmessageAgreeAPI: HelpmessegeAgreeAPI()
                             )
        )
    }

    func navigate(_ destination: HelpmessageAgreeNavigationDestination) {
        switch destination {
        case .back:
            moduleViewController.navigationController?.popViewController(animated: true)
        }
    }
}
