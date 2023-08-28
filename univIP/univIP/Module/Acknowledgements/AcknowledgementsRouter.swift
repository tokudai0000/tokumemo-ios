//
//  AcknowledgementsRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

import Foundation
import UIKit
import Core

enum AcknowledgementsNavigationDestination {
    case back
}

protocol AcknowledgementsRouterInterface {
    func navigate(_ destination: AcknowledgementsNavigationDestination)
}

final class AcknowledgementsRouter: BaseRouter, AcknowledgementsRouterInterface {
    init() {
        let viewController =  R.storyboard.acknowledgements.acknowledgementsViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = AcknowledgementsViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self)
        )
    }

    func navigate(_ destination: AcknowledgementsNavigationDestination) {
        switch destination {
        case .back:
            moduleViewController.navigationController?.popViewController(animated: true)
        }
    }
}
