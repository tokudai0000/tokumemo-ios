//
//  UIImageView.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/20.
//

import UIKit.UIImageView

extension UIImageView {
    
    // NSCacheのインスタンスを生成しておく。ここに、どんどんキャッシュ化されたものが保存されていく。
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    // 読み込むURLのstringを引数にする。
    func loadCacheImage(urlStr: String) {
        
        // "NoImage" は常設の画像を表示
        if urlStr == "NoImage" {
            self.image = UIImage(resource: R.image.noImage)
            return
        }
        
        let url = URL(string: urlStr)
        
        //　引数で渡されたurlStrがすでにキャッシュとして保存されている場合は、キャッシュからそのimageを取り出す
        if let imageFromCache = UIImageView.imageCache.object(forKey: urlStr as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        // キャッシュとして保存
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            if error != nil {
                AKLog(level: .ERROR, message: error!)
                return
            }
            
            // UIKitのオブジェクトは必ずメインスレッドで実行しなければならない
            DispatchQueue.main.async {
                let imageToCache = UIImage(data:data!)
                self.image = imageToCache
                
                let dt = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.setTemplate(.dateMonthDate)
                
                let key = urlStr + dateFormatter.string(from: dt)
                
                // keyをurlStr + 日付 として、imageToCacheをキャッシュとして保存する。
                UIImageView.imageCache.setObject(imageToCache!, forKey: key as AnyObject)
            }
        }.resume()
    }
}
