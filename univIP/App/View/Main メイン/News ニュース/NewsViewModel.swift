//
//  NewsViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/06.
//

import Foundation
import Kanna
import Alamofire
import SwiftyJSON

final class NewsViewModel {
    
    private let dataManager = DataManager.singleton
    private let apiManager = ApiManager.singleton
    
    
    struct NewsData {
        let title: String
        let date: String
        let urlStr: String
    }
    // Newsの基本データ情報を保存
    public var newsDatas = [
        NewsData(title: "",
                 date: "",
                 urlStr: "")
    ]
    
    
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
            
            self.newsDatas.removeAll()
            
            var counter = 0
            while(true) {
                guard let title = response["items"][counter]["title"].string,
                      let date = response["items"][counter]["pubDate"].string,
                      let urlStr = response["items"][counter]["link"].string else{
                    break
                }
                let data = NewsData(title: title,
                                    date: date,
                                    urlStr: urlStr)
                self.newsDatas.append(data)
                counter += 1
            }
            
            self.state?(.ready) // 通信完了
        }, failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
            self?.state?(.error) // エラー表示
        })
    }
}
