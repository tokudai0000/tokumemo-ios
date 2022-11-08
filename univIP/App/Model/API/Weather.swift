//
//  WeatherAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/14.
//

import Foundation
import SwiftyJSON

extension ApiManager {
    public func request(_ urlStr: String,
                        success: @escaping (_ response: JSON) -> (),
                        failure: @escaping (_ error: ApiError) -> ()) {
        
        AKLog(level: .DEBUG, message: "\(urlStr)")
        
        manager.session.configuration.timeoutIntervalForRequest = API_TIMEOUT // リクエスト開始まで
        manager.session.configuration.timeoutIntervalForResource = API_RESPONSE_TIMEOUT // リクエスト開始からレスポンス終了まで
        
        manager.request(urlStr).responseJSON { response in
            guard let object = response.result.value else {
                failure(ApiError.none)
                return
            }
            success(JSON(object))
            return
        }
    }
}
