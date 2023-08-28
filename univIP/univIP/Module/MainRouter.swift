//
//  MainRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Core

final class MainRouter: BaseRouter {
    init() {
        let viewController = MainViewController()
        super.init(moduleViewController: viewController)
    }
}
