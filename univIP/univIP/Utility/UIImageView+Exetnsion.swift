//
//  UIImageView.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Data loading or Image initialization failed")
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
