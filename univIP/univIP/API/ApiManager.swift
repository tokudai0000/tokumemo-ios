//
//  ApiManager.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/05.
//


import APIKit
import Foundation
import RxSwift

protocol AnnotateImageAPIInterface {
    func postAnnotateImage(imageBase64String: String) -> Single<AnnotateImagePostRequest.Response>
}

struct AnnotateImageAPI: AnnotateImageAPIInterface {
    let apiKey: String

    func postAnnotateImage(imageBase64String: String) -> RxSwift.Single<AnnotateImagePostRequest.Response> {
        let request = AnnotateImagePostRequest(apiKey: AppConstants.API.key, base64String: imageBase64String)
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

// API仕様はこちらを参照
// https://cloud.google.com/vision/docs/detecting-fulltext?hl=ja
// https://cloud.google.com/vision/docs/reference/rest/v1/images/annotate?hl=ja#AnnotateImageRequest
struct AnnotateImagePostRequest: Request {
    struct ResponseBody: Decodable {
        let responses: [AnnotateImage]
    }

    typealias Response = ResponseBody

    var apiKey: String
    var base64String: String

    var baseURL: URL {
        return URL(string: "https://vision.googleapis.com")!
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
//        return "/v1/images:annotate"
        return "/v1p4beta1/images:annotate"
    }

    var queryParameters: [String: Any]? {
        return [
            "key": apiKey
        ]
    }

    var bodyParameters: BodyParameters? {
        let json: [String: Any] = [
            "requests": [
                "image": [
                    "content": "\(base64String)"
                ],
                "features": [[
                    "type": "DOCUMENT_TEXT_DETECTION",
                    "maxResults": 30,
                    "model": "builtin/latest"
                ]]
            ]
        ]

        return JSONBodyParameters(JSONObject: json)
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        // ResponseがDecodableに準拠していなければパースされない
        guard let response = object as? Response else {
            throw ResponseError.unexpectedObject(object)
        }
        return response
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
