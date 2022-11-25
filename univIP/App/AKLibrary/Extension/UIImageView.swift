//
//  UIImageView.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/20.
//

import UIKit

extension UIImageView {
    
    //NSCacheのインスタンスを生成しておく。ここに、どんどんキャッシュ化されたものが保存されていく。
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    //読み込むURLのstringを引数にする。
    func cacheImage(imageUrlString: String) {
        
        if imageUrlString == "NoImage" {
            let imageToCache = UIImage(resource: R.image.noImage)
            self.image = imageToCache
            return
        }
        
        //引数のimageUrlStringをURLに型変換する。
        let url = URL(string: imageUrlString)
        
        //引数で渡されたimageUrlStringがすでにキャッシュとして保存されている場合は、キャッシュからそのimageを取り出し、self.imageに代入し、returnで抜ける。
        if let imageFromCache = UIImageView.imageCache.object(forKey: imageUrlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        //上記のifに引っかからないということは、キャッシュとして保存されていないということなので、以下でキャッシュ化をしていく。
        //URLSessionクラスのdataTaskメソッドで、urlを元にして、バックグランドでサーバーと通信を行う。
        //{ 以降はcompletionHandler(クロージャー)で、通信処理が終わってから実行される。
        //dataはサーバーからの返り値。urlResponseは。HTTPヘッダーやHTTPステータスコードなどの情報。リクエストが失敗したときに、errorに値が入力される。失敗しない限り、nilとなる。
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            
            //errorがnilじゃないということは、リクエストに失敗しているということ。returnで抜け出す。
            if error != nil {
                print(error!)
                return
            }
            
            //リクエストが成功して、サーバーからのresponseがある状態。
            //しかし、UIKitのオブジェクトは必ずメインスレッドで実行しなければならないので、DispatchQueue.mainでメインキューに処理を追加する。非同期で登録するので、asyncで実装。
            DispatchQueue.main.async {
                
                //サーバーからのレスポンスのdataを元にして、UIImageを取得し、imageToCacheに代入。
                let imageToCache = UIImage(data:data!)
                
                //self.imageにimageToCacheを代入。
                self.image = imageToCache
                
                //keyをimageUrlStringとして、imageToCacheをキャッシュとして保存する。
                UIImageView.imageCache.setObject(imageToCache!, forKey: imageUrlString as AnyObject)
            }
        }.resume()
    }
}
