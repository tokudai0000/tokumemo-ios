//
//  NumberOfUsers.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/18.
//

import APIKit
import RxSwift

public protocol NumberOfUsersAPIInterface {
    func getNumberOfUsers() -> Single<NumberOfUsersGetRequest.Response>
}

public struct NumberOfUsersAPI: NumberOfUsersAPIInterface {
    public init() {}
    
    public func getNumberOfUsers() -> RxSwift.Single<NumberOfUsersGetRequest.Response> {
        let request = NumberOfUsersGetRequest()
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

public struct NumberOfUsersGetRequest: Request {
    public struct ResponseBody: Decodable {
        public let numberOfUsers: String

        public init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let users = dictionary["numberOfUsers"] as? String else {
                throw ResponseError.unexpectedObject(object)
            }
            numberOfUsers = users
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
        return "/tokumemo_resource/api/v1/number_of_users.json"
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
