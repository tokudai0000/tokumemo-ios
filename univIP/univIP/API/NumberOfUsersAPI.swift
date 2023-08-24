//
//  NumberOfUsers.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/18.
//

import APIKit
import RxSwift

protocol NumberOfUsersAPIInterface {
    func getNumberOfUsers() -> Single<NumberOfUsersGetRequest.Response>
}

struct NumberOfUsersAPI: NumberOfUsersAPIInterface {
    func getNumberOfUsers() -> RxSwift.Single<NumberOfUsersGetRequest.Response> {
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

struct NumberOfUsersGetRequest: Request {
    struct ResponseBody: Decodable {
        let numberOfUsers: String

        init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let users = dictionary["numberOfUsers"] as? String else {
                throw ResponseError.unexpectedObject(object)
            }
            numberOfUsers = users
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
        return "/tokumemo_resource/api/v1/number_of_users.json"
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
