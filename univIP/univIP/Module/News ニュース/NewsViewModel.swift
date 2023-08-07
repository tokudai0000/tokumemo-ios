//
//  NewsViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/06.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Alamofire
import SwiftyJSON

final class NewsViewModel {
    
    // 共通データ・マネージャ
    public let dataManager = DataManager.singleton
    
    // API マネージャ
//    public let apiManager = ApiManager.singleton
    
    
    struct NewsData {
        let title: String
        let date: String
        let urlStr: String
    }
    
    public var newsItems: [NewsData] = []
    
    //MARK: - STATE ステータス
    
    enum State {
        case busy
        case ready
        case error
    }
    public var state: ((State) -> Void)?
    
    // MARK: - Methods [Public]
    
    public func updateNewsItems() {
//        state?(.busy) // 通信開始（通信中）
//        newsItems.removeAll()
//        apiManager.request(Url.newsItemJsonData.string(),
//                           success: { [weak self] (response) in
//            guard let self = self else {
//                AKLog(level: .FATAL, message: "[self] FatalError")
//                fatalError()
//            }
//            for i in 0 ..< 50 { // MAX50件
//                guard let title = response["items"][i]["title"].string,
//                      let date = response["items"][i]["pubDate"].string,
//                      let urlStr = response["items"][i]["link"].string else{
//                    break
//                }
//                let data = NewsData(title: title, date: date, urlStr: urlStr)
//                self.newsItems.append(data)
//            }
//            self.state?(.ready) // 通信完了
//        }, failure: { [weak self] (error) in
//            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
//            self?.state?(.error) // エラー表示
//        })
    }
}
