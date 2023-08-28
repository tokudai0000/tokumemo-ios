//
//  MainViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import UIKit
import Common

final class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }

    func configureViewControllers() {
        let homeViewController = HomeRouter().moduleViewController
        homeViewController.tabBarItem = UITabBarItem(title: Common.R.string.localizable.home(),
                                                     image: Common.R.image.tabIcon.home(),
                                                     selectedImage: nil)

        let newsViewController = NewsRouter().moduleViewController
        newsViewController.tabBarItem = UITabBarItem(title: Common.R.string.localizable.news(),
                                                     image: Common.R.image.tabIcon.news(),
                                                     selectedImage: nil)

        let clubListsViewController = ClubListsRouter().moduleViewController
        clubListsViewController.tabBarItem = UITabBarItem(title: Common.R.string.localizable.club_lists(),
                                                          image: Common.R.image.tabIcon.clubLists(),
                                                         selectedImage: nil)

        let settingsViewController = UINavigationController(rootViewController: SettingsRouter().moduleViewController)
        settingsViewController.tabBarItem = UITabBarItem(title: Common.R.string.localizable.settings(),
                                                         image: Common.R.image.tabIcon.settings(),
                                                         selectedImage: nil)

        viewControllers = [homeViewController, newsViewController, clubListsViewController, settingsViewController]
    }
}
