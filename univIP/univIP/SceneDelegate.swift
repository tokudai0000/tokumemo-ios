//
//  SceneDelegate.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/06.
//  Copyright © 2021年　akidon0000
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // 利用規約に同意する必要があるかどうか
//        if DataManager.singleton.agreementVersion == AppConstants.latestTermsVersion {
////            let vc = R.storyboard.splash.instantiateInitialViewController()!
////            self.window?.rootViewController = vc
////            self.window?.makeKeyAndVisible()
//        }else{
//            let vc = R.storyboard.agreement.agreemantViewController()!
//            self.window?.rootViewController = vc
//            self.window?.makeKeyAndVisible()
//        }
//        window = UIWindow(frame: UIScreen.main.bounds)

//        window?.rootViewController = UINavigationController(rootViewController: HomeRouter().moduleViewController)
//        window?.rootViewController = UIController(rootViewController: HomeRouter().moduleViewController)
        window?.rootViewController = UINavigationController(rootViewController: AgreementRouter().moduleViewController)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    func showLaunchScreen() {
        // Launch画面のStoryboardを取得
        let launchStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        
        // Launch画面のViewControllerを取得
        if let launchViewController = launchStoryboard.instantiateInitialViewController() {
            
            // Launch画面を現在のウィンドウに追加
            self.window?.rootViewController?.view.addSubview(launchViewController.view)
            
            // 1秒後にLaunch画面を削除する
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                launchViewController.view.removeFromSuperview()
            }
        }
    }
}

