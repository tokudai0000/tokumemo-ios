//
//  CurrentTermVersionAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/18.
//

import APIKit
import RxSwift

protocol CurrentTermVersionAPIInterface {
    func getCurrentTermVersion() -> Single<CurrentTermVersionGetRequest.Response>
}

struct CurrentTermVersionAPI: CurrentTermVersionAPIInterface {
    init() {}
    
    func getCurrentTermVersion() -> RxSwift.Single<CurrentTermVersionGetRequest.Response> {
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

struct CurrentTermVersionGetRequest: Request {
    struct ResponseBody: Decodable {
        let currentTermVersion: String
        
        init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let termVersion = dictionary["currentTermVersion"] as? String else {
                throw ResponseError.unexpectedObject(object)
            }
            currentTermVersion = termVersion
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
        return "/tokumemo_resource/api/v1/current_term_version.json"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
