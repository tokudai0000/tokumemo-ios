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
    var backgroundedAt: Date?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // シュミレーターではアナリティクスを起動させない
        #if !targetEnvironment(simulator)
            FirebaseApp.configure()
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    // アプリがバックグラウンドに移行するときに現在の時間を保存
    func applicationDidEnterBackground(_ application: UIApplication) {
        backgroundedAt = Date()
    }

    // Home画面では常にログイン完了状態で居たい。その為、アプリ復帰時にはSplashからやり直し
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let backgroundedAt = backgroundedAt else {
            return
        }

        let backGroudTimeSec = 600.0 // 10分
        if backGroudTimeSec < backgroundedAt.distance(to: Date()) {
            window?.rootViewController = RootViewController()
            window?.makeKeyAndVisible()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
