//
//  MainViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import UIKit

final class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
    }

    func configureViewControllers() {

        let homeRouter = HomeRouter()
        let homeVC = homeRouter.moduleViewController
        homeVC.tabBarItem = UITabBarItem(title: R.string.localizable.home(),
                                         image: R.image.tabIcon.home(),
                                         selectedImage: nil)

        let newsRouter = NewsRouter()
        let newsVC = newsRouter.moduleViewController
        newsVC.tabBarItem = UITabBarItem(title: R.string.localizable.news(),
                                         image: R.image.tabIcon.news(),
                                         selectedImage: nil)

        let clubListRouter = ClubListRouter()
        let clubListVC = clubListRouter.moduleViewController
        clubListVC.tabBarItem = UITabBarItem(title: R.string.localizable.club_lists(),
                                             image: R.image.tabIcon.clubLists(),
                                             selectedImage: nil)

        let settingsRouter = SettingsRouter()
        let settingsVC = settingsRouter.moduleViewController
        settingsVC.tabBarItem = UITabBarItem(title: R.string.localizable.settings(),
                                             image: R.image.tabIcon.settings(),
                                             selectedImage: nil)


        viewControllers = [homeVC, newsVC, clubListVC, settingsVC]
    }
}
