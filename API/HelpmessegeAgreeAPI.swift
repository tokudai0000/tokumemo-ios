//
//  HelpmessegeAgreeAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/20.
//

import APIKit
import RxSwift

public protocol HelpmessegeAgreeAPIInterface {
    func getHelpmessegeAgree() -> Single<HelpmessegeAgreeGetRequest.Response>
}

public struct HelpmessegeAgreeAPI: HelpmessegeAgreeAPIInterface {
    public init() {}
    
    public func getHelpmessegeAgree() -> RxSwift.Single<HelpmessegeAgreeGetRequest.Response> {
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

public struct HelpmessegeAgreeGetRequest: Request {
    public struct ResponseBody: Decodable {
        public let helpmessageAgreeText: String

        public init(object: Any) throws {
            guard let dictionary = object as? [String: Any],
                  let helpmessageAgree = dictionary["helpmessageAgree"] as? String else {
                throw ResponseError.unexpectedObject(object)
            }
            helpmessageAgreeText = helpmessageAgree
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
        return "/tokumemo_resource/api/v1/helpmessage_agree.json"
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try Response(object: object)
    }
}
