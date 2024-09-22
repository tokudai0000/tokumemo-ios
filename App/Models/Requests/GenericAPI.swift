//
//  GenericAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/21.
//

import APIKit
import RxSwift

protocol GenericAPIInterface {
    associatedtype RequestType: GenericAPIRequest
    func getResponse() -> Single<RequestType.ResponseBody>
}

protocol GenericAPIRequest: Request {
    associatedtype ResponseBody: DecodableAPIResponse
    var endPoint: String { get }
    init()
}

protocol DecodableAPIResponse: Decodable {
    init(object: Any) throws
}

struct GenericAPI<T: GenericAPIRequest>: GenericAPIInterface {
    typealias RequestType = T

    func getResponse() -> RxSwift.Single<T.ResponseBody> {
        let request = T()
        return .create { observer in
            let session = Session.send(request) { result in
                switch result {
                case let .success(response):
                    observer(.success(response as! T.ResponseBody))
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
