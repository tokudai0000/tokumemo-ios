//
//  HomeRouter.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/07.
//

import Foundation

enum HomeNavigationDestination {
    case goWeb(URLRequest)
    case detail(AdItem)
}

protocol HomeRouterInterface {
    func navigate(_ destination: HomeNavigationDestination)
}

final class HomeRouter: BaseRouter, HomeRouterInterface {
    init() {
        let viewController = R.storyboard.home.homeViewController()!
        super.init(moduleViewController: viewController)
        viewController.viewModel = HomeViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: self,
                              adItemsAPI: AdItemsAPI(),
                              numberOfUsersAPI: NumberOfUsersAPI(),
                              homeEventInfos: HomeEventInfosAPI(),
                              libraryCalendarWebScraper: LibraryCalendarWebScraper()
                             )
        )
    }

    func navigate(_ destination: HomeNavigationDestination) {
        switch destination {
        case .goWeb(let urlRequest):
            present(WebRouter(loadUrl: urlRequest))
        case .detail(let item):
            present(PRRouter(prItem: item), presentationStyle: .automatic)
        }
    }
}
