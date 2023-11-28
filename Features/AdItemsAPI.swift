//
//  AdItemsAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/05.
//

import APIKit
import RxSwift
import Entity

/// AdItemはPRアイテムとUnivアイテムで使用する
/// PRアイテムは大学生が大学生に向けて告知したい内容。比較的掲載が簡単
/// Univアイテムは教員や学生が、大学生に向けて有用な情報だと判断した内容。
public protocol AdItemsAPIInterface {
    func getAdItems() -> Single<AdItemsGetRequest.Response>
}

public struct AdItemsAPI: AdItemsAPIInterface {
    public init() {}
    
    public func getAdItems() -> RxSwift.Single<AdItemsGetRequest.Response> {
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

public struct AdItemsGetRequest: Request {
    public struct ResponseBody {
        public let adItems:AdItems

        public init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let prItemsArray = dictionary["prItems"] as? [[String: Any]],
                  let univItemsArray = dictionary["univItems"] as? [[String: Any]] else {
                throw ResponseError.unexpectedObject(object)
            }

            let prItems = try prItemsArray.map { try AdItem(dictionary: $0) }
            let univItems = try univItemsArray.map { try AdItem(dictionary: $0) }
            adItems = AdItems(prItems: prItems, univItems: univItems)
        }
    }

    public typealias Response = ResponseBody

    public var baseURL: URL {
        return URL(string: "https://tokudai0000.github.io")!
    }

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return "/tokumemo_resource/api/v1/ad_items.json"
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
