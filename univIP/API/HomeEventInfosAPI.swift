//
//  HomeEventInfosAPI.swift
//  API
//
//  Created by Akihiro Matsuyama on 2023/08/29.
//

import APIKit
import RxSwift
import Entity

public protocol HomeEventInfosAPIInterface {
    func getHomeEventInfos() -> Single<HomeEventInfosGetRequest.Response>
}

public struct HomeEventInfosAPI: HomeEventInfosAPIInterface {
    public init() {}

    public func getHomeEventInfos() -> RxSwift.Single<HomeEventInfosGetRequest.Response> {
        let request = HomeEventInfosGetRequest()
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

public struct HomeEventInfosGetRequest: Request {
    public struct ResponseBody: Decodable {
        public let homeEventInfos: HomeEventInfos

        public init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let popupArray = dictionary["popupItems"] as? [[String: Any]],
                  let buttonArray = dictionary["buttonItems"] as? [[String: Any]] else {
                throw ResponseError.unexpectedObject(object)
            }

            let popupItems = try popupArray.map { try HomeEventInfos.PopupItem(dictionary: $0) }
            let buttonItems = try buttonArray.map { try HomeEventInfos.ButtonItem(dictionary: $0) }
            homeEventInfos = HomeEventInfos(popupItems: popupItems, buttonItems: buttonItems)
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
        return "/tokumemo_resource/api/v1/home_event_infos.json"
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
