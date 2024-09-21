//
//  TermTextAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/18.
//

import APIKit
import RxSwift

protocol TermTextAPIInterface {
    func getTermText() -> Single<TermTextGetRequest.Response>
}

struct TermTextAPI: TermTextAPIInterface {
    init() {}
    
    func getTermText() -> RxSwift.Single<TermTextGetRequest.Response> {
        let request = TermTextGetRequest()
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

struct TermTextGetRequest: Request {
    struct ResponseBody: Decodable {
        let termText: String
        
        init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let text = dictionary["termText"] as? String else {
                throw ResponseError.unexpectedObject(object)
            }
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
        return "/tokumemo_resource/api/v1/term_text.json"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
