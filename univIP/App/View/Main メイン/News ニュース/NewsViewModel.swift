//
//  NewsViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/06.
//

import Foundation
import Alamofire
import SwiftyJSON

final class NewsViewModel {
    // MARK: - Private
    private let dataManager = DataManager.singleton
    private let apiManager = ApiManager.singleton
    
    //MARK: - STATE ステータス
    enum State {
        case busy           // 準備中 -->
        case ready          // 準備完了 -->
        case error          // エラー発生 -->
    }
    public var state: ((State) -> Void)?
    
    public func getNewsData() {
        state?(.busy) // 通信開始（通信中）
        let urlString = "https://api.rss2json.com/v1/api.json?rss_url=https://www.tokushima-u.ac.jp/recent/rss.xml"
        
        apiManager.request(urlString,
                            success: { [weak self] (response) in
            guard let self = self else { // SearchViewModelのself
                AKLog(level: .FATAL, message: "[self] FatalError")
                fatalError()
            }
//            print(response.description)
            for i in 0..<10 {
                self.dataManager.newsTitleDatas.append(response["items"][i]["title"].string!)
                self.dataManager.newsUrlDatas.append(response["items"][i]["link"].string!)
                self.dataManager.newsDateDatas.append(response["items"][i]["pubDate"].string!)
            }
            
//            if let a = response["weather"][0]["description"].string {
//                self.dataManager.weatherDatas[0] = a
//            }
//            if let b = response["main"]["feels_like"].double {
//                self.dataManager.weatherDatas[1] = String(b)
//            }
//            if let c = response["weather"][0]["icon"].string {
//                let url = "https://openweathermap.org/img/wn/" + c + "@2x.png"
//                self.dataManager.weatherDatas[2] = url
//            }
            
            self.state?(.ready) // 通信完了
        }, failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
            self?.state?(.error) // エラー表示
        })
    }
}
