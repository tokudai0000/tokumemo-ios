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
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=34.0778755&lon=134.5615651&appid=e0578cd3fb0d436dd64d4d5d5a404f08&lang=ja&units=metric"
        
        apiManager.download(urlString: urlString,
                            success: { [weak self] (response) in
            guard let self = self else { // SearchViewModelのself
                AKLog(level: .FATAL, message: "[self] FatalError")
                fatalError()
            }
            
            if let a = response["weather"][0]["description"].string {
                self.dataManager.weatherDatas[0] = a
            }
            if let b = response["main"]["feels_like"].double {
                self.dataManager.weatherDatas[1] = String(b)
            }
            if let c = response["weather"][0]["icon"].string {
                let url = "https://openweathermap.org/img/wn/" + c + "@2x.png"
                self.dataManager.weatherDatas[2] = url
            }
            
            self.state?(.ready) // 通信完了
        }, failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
            self?.state?(.error) // エラー表示
        })
    }
}
