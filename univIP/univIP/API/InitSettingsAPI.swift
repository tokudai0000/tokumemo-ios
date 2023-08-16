//
//  InitSettingsAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import APIKit
import RxSwift

protocol InitSettingsAPIInterface {
    func getInitSettings() -> Single<InitSettingsGetRequest.Response>
}

struct InitSettingsAPI: InitSettingsAPIInterface {
    func getInitSettings() -> RxSwift.Single<InitSettingsGetRequest.Response> {
        let request = InitSettingsGetRequest()
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

struct InitSettingsGetRequest: Request {
    struct ResponseBody: Decodable {
        let numberOfUsers: String
        let currentTermVersion: String
        let termText: String

        init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let users = dictionary["numberOfUsers"] as? String,
                  let termVersion = dictionary["currentTermVersion"] as? String,
                  let text = dictionary["termText"] as? String else {
                throw ResponseError.unexpectedObject(object)
            }
            numberOfUsers = users
            currentTermVersion = termVersion
            termText = text
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
        return "/tokumemo_resource/api/v1/init_settings.json"
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
