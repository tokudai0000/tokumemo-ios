//
//  CurrentTermVersionAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/18.
//

import APIKit
import RxSwift

public protocol CurrentTermVersionAPIInterface {
    func getCurrentTermVersion() -> Single<CurrentTermVersionGetRequest.Response>
}

public struct CurrentTermVersionAPI: CurrentTermVersionAPIInterface {
    public init() {}
    
    public func getCurrentTermVersion() -> RxSwift.Single<CurrentTermVersionGetRequest.Response> {
        let request = CurrentTermVersionGetRequest()
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

public struct CurrentTermVersionGetRequest: Request {
    public struct ResponseBody: Decodable {
        public let currentTermVersion: String

        init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let termVersion = dictionary["currentTermVersion"] as? String else {
                throw ResponseError.unexpectedObject(object)
            }
            currentTermVersion = termVersion
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
        return "/tokumemo_resource/api/v1/current_term_version.json"
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
