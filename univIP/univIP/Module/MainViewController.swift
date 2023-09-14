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
        let homeViewController = HomeRouter().moduleViewController
        homeViewController.tabBarItem = UITabBarItem(title: R.string.localizable.home(),
                                                     image: R.image.tabIcon.home(),
                                                     selectedImage: nil)

        let newsViewController = NewsRouter().moduleViewController
        newsViewController.tabBarItem = UITabBarItem(title: R.string.localizable.news(),
                                                     image: R.image.tabIcon.news(),
                                                     selectedImage: nil)

        let clubListsViewController = ClubListsRouter().moduleViewController
        clubListsViewController.tabBarItem = UITabBarItem(title: R.string.localizable.club_lists(),
                                                          image: R.image.tabIcon.clubLists(),
                                                         selectedImage: nil)

        let settingsViewController = UINavigationController(rootViewController: SettingsRouter().moduleViewController)
        settingsViewController.tabBarItem = UITabBarItem(title: R.string.localizable.settings(),
                                                         image: R.image.tabIcon.settings(),
                                                         selectedImage: nil)

        viewControllers = [homeViewController, newsViewController, clubListsViewController, settingsViewController]
    }
}
