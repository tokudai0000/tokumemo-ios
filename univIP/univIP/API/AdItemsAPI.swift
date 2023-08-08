//
//  ApiManager.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/05.
//

import APIKit
import RxSwift
import SwiftyJSON

/// AdItemはPRアイテムとUnivアイテムで使用する
/// PRアイテムは大学生が大学生に向けて告知したい内容。比較的掲載が簡単
/// Univアイテムは教員や学生が、大学生に向けて有用な情報だと判断した内容。
protocol AdItemsAPIInterface {
    func getAdItems() -> Single<AdItemsGetRequest.Response>
}

struct AdItemsAPI: AdItemsAPIInterface {
    func getAdItems() -> RxSwift.Single<AdItemsGetRequest.Response> {
        let request = AdItemsGetRequest()
        return .create { observer in
            let session = Session.send(request) { result in
                switch result {
                case let .success(response):
                    observer(.success(response))
                case let .failure(error):
                    observer(.failure(error))
                }
            }
            return Disposables.create {
                session?.cancel()
            }
        }
    }
}

struct AdItemsGetRequest: Request {
    struct ResponseBody: Decodable {
        let prItems: [AdItem]
        let univItems: [AdItem]

        init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let prItemsArray = dictionary["prItems"] as? [[String: Any]],
                  let univItemsArray = dictionary["univItems"] as? [[String: Any]] else {
                throw ResponseError.unexpectedObject(object)
            }

            prItems = try prItemsArray.map { try AdItem(dictionary: $0) }
            univItems = try univItemsArray.map { try AdItem(dictionary: $0) }
        }
    }

    typealias Response = ResponseBody

    var baseURL: URL {
        return URL(string: "https://tokudai0000.github.io")!
    }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/tokumemo_resource/api/v1/ad_items.json"
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}


//import Foundation
//import Network
//import Alamofire
//import SwiftyJSON
//
///// 通信タイムアウト時間　（方式設計指定値  リクエスト:30s　レスポンス:60s）
//let API_TIMEOUT: TimeInterval = 10.0
//let API_RESPONSE_TIMEOUT: TimeInterval = 10.0
///// HTTPステータス有効(成功)範囲
//let API_HTTP_VALIDATE_STATUS = 200..<201
//
///// APIエラー
//public enum ApiError: Error {
//    case none               // なし（正常）
//    case notAvailable       // 通信不可
//    case timeout            // タイムアウト
//    case invalidURL         // URL不正
//    case badResponse        // 応答不正
//    case unknown(String)    // 未知
//    case alert(String)      // アラート表示
//}
//
////MARK: - リクエスト・ベースクラス
//
//protocol ApiRequest: Codable {
//    /// JSON-Dictionaryを返却
//    ///
//    /// - Returns: JSON-Dictionary
//    func toDict() -> [String: Any]?
//
//    /// JSON-Dataを返却
//    ///
//    /// - Returns: JSON-Data
//    func toData() -> Data?
//}
//
//extension ApiRequest {
//    /// JSON-Dictionaryを返却
//    ///
//    /// - Returns: JSON-Dictionary
//    func toDict() -> [String: Any]? {
//        do {
//            return try JSONSerialization.jsonObject(with: toData()!, options: .allowFragments) as? [String: Any]
//        } catch (let error) {
//            AKLog(level: .ERROR, message: "[API] JSONSerialization Error:\(error)")
//            return nil
//        }
//    }
//
//    /// JSON-Dataを返却
//    ///
//    /// - Returns: JSON-Data
//    func toData() -> Data? {
//        do {
//            return try JSONEncoder().encode(self)
//        } catch (let error) {
//            AKLog(level: .ERROR, message: "[API] JSONEncoder Error:\(error)")
//            return nil
//        }
//    }
//}
//
//class ApiManager: NSObject {
//
//    // MARK: - Public value
//    static let singleton = ApiManager() // シングルトン・インタンス
//
//    // ネットワーク接続状態
//    private var isConnected = false
//
//    // タイムアウト設定
//    let manager = Alamofire.SessionManager.default
//    let headers: HTTPHeaders = ["Content-Type": "application/json"]
//
//    /// シングルトン・インスタンスの初期処理
//    private override init() {  //シングルトン保証// privateにすることにより他から初期化させない
//        super.init()
//
//        // ネットワーク接続状態のモニタリング
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                // Connect
//                self?.isConnected = true
//            } else {
//                // Disconnect
//                self?.isConnected = false
//                AKLog(level: .WARN, message: "[Network] Disconnect")
//            }
//        }
//        let queue = DispatchQueue(label: "com.akidon0000.queue")
//        monitor.start(queue: queue)
//    }
//}
//
//extension ApiManager {
//    public func request(_ urlStr: String,
//                        success: @escaping (_ response: JSON) -> (),
//                        failure: @escaping (_ error: ApiError) -> ()) {
//
//        AKLog(level: .DEBUG, message: "\(urlStr)")
//
//        manager.session.configuration.timeoutIntervalForRequest = API_TIMEOUT // リクエスト開始まで
//        manager.session.configuration.timeoutIntervalForResource = API_RESPONSE_TIMEOUT // リクエスト開始からレスポンス終了まで
//
//        manager.request(urlStr).responseJSON { response in
//            guard let object = response.result.value else {
//                failure(ApiError.none)
//                return
//            }
//            success(JSON(object))
//            return
//        }
//    }
//}
