//
//  SettingsRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation
import UIKit

enum SettingsNavigationDestination {
    case goWeb(URLRequest)
    case modal(BaseRouter)
}

protocol SettingsRouterInterface {
    func navigate(_ destination: SettingsNavigationDestination)
}

final class SettingsRouter: BaseRouter, SettingsRouterInterface {
    init() {
        let viewController = R.storyboard.settings.settingsViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = SettingsViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self)
        )
    }

    func navigate(_ destination: SettingsNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        case .modal(let router):
            push(router)
        }
    }
}
