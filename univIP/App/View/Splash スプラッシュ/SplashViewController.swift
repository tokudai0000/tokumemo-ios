//
//  SplashViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/04/06.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
//    var viewActivityIndicator: UIActivityIndicatorView! // ログイン中のクルクル
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateLabel.text = "ログイン中"

        // viewActivityIndicator(ログイン中のクルクル)
//        viewActivityIndicator = UIActivityIndicatorView(style: .large)
//        viewActivityIndicator.hidesWhenStopped = true // クルクルをストップした時に非表示する
//        viewActivityIndicator.center = CGPoint(x: self.view.frame.midX, y: self.view.bounds.maxY - CGFloat(100))
//        viewActivityIndicator.color =  R.color.mainColor() // 色を設定
//        self.view.addSubview(viewActivityIndicator)
        viewActivityIndicator.startAnimating()
    }
    
}
