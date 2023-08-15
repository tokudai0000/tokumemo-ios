//
//  AppDelegate.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/06.
//  Copyright © 2021年　akidon0000
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // アナリティクスをシュミレーターでは起動させない
        #if !targetEnvironment(simulator)
            FirebaseApp.configure()
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashRouter().moduleViewController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
