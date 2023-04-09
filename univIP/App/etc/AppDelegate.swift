//
//  AppDelegate.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/06.
//  Copyright © 2021年　akidon0000
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // アナリティクスをシュミレーターでは起動させない
        #if !targetEnvironment(simulator)
            FirebaseApp.configure()
        #endif
        
        return true
    }
}
