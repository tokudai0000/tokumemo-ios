//
//  UIImage.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit

extension UIImage {
    /// URLを指定し、画像Dataを取得
    convenience init?(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
            return
        } catch let err {
            AKLog(level: .ERROR, message: "\(err.localizedDescription)")
        }
        self.init()
    }
}
