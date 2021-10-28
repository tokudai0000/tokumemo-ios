//
//  UI.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/25.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 画像をURLより読み込んで表示する(非同期)
    func loadUrl(urlString: String) {
        self.image = nil
        guard let url = URL(string: urlString) else {
            AKLog(level: .WARN, message: "NoImage")
            return
        }
        DispatchQueue.global().async {
            do {
                let imageData: Data? = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.image = UIImage(data: data)
                    } else {
//                        self.image = defaultUIImage
                        return
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
//                    self.image = defaultUIImage
                    return
                }
            }
        }
    }
    
}
