//
//  Notification.Name.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/18.
//

import UIKit


extension Notification.Name {
    
    //カスタム通知// カスタム・ローディング表示が終了した（閉じた）
    static let didHideIndicator = Notification.Name("didHideIndicator")
    
    //カスタム通知// toast表示が終了した（閉じた）
    static let didHideToast = Notification.Name("didHideToast")
    
}
