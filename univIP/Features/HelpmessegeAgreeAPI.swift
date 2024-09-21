//
//  HelpmessegeAgreeAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/20.
//

import APIKit
import RxSwift

protocol HelpmessegeAgreeAPIInterface {
    func getHelpmessegeAgree() -> Single<HelpmessegeAgreeGetRequest.Response>
}

struct HelpmessegeAgreeAPI: HelpmessegeAgreeAPIInterface {
    init() {}
    
    func getHelpmessegeAgree() -> RxSwift.Single<HelpmessegeAgreeGetRequest.Response> {
        let request = HelpmessegeAgreeGetRequest()
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

struct HelpmessegeAgreeGetRequest: Request {
    struct ResponseBody: Decodable {
        let helpmessageAgreeText: String
        
        init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let helpmessageAgree = dictionary["helpmessageAgree"] as? String else {
                throw ResponseError.unexpectedObject(object)
            }
            helpmessageAgreeText = helpmessageAgree
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
        return "/tokumemo_resource/api/v1/helpmessage_agree.json"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
