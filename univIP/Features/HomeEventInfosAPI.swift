//
//  HomeEventInfosAPI.swift
//  API
//
//  Created by Akihiro Matsuyama on 2023/08/29.
//

import APIKit
import RxSwift

protocol HomeEventInfosAPIInterface {
    func getHomeEventInfos() -> Single<HomeEventInfosGetRequest.Response>
}

struct HomeEventInfosAPI: HomeEventInfosAPIInterface {
    init() {}

    func getHomeEventInfos() -> RxSwift.Single<HomeEventInfosGetRequest.Response> {
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

struct HomeEventInfosGetRequest: Request {
    struct ResponseBody: Decodable {
        let homeEventInfos: HomeEventInfos

        init(object: Any) throws {
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

    typealias Response = ResponseBody

    var baseURL: URL {
        return URL(string: "https://tokudai0000.github.io")!
    }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/tokumemo_resource/api/v1/home_event_infos.json"
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
