//
//  ReviewViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import StoreKit

class ReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            SKStoreReviewController.requestReview(in: scene)
//        }
        
        // ステータスバーの背景色を指定
        setStatusBarBackgroundColor(UIColor(red: 13/255, green: 58/255, blue: 151/255, alpha: 1.0))
    }
    
    // ステータスバーのスタイルを白に設定
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
}
