//
//  UIImage.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit

extension UIImage {
    // URL画像を表示できる。
    // 使用例：imageView.image = UIImage(url: "https://openweathermap.org/img/wn/02d@2x.png")
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
