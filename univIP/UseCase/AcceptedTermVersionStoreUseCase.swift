//
//  AcceptedTermVersionStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation
import Repository

public protocol AcceptedTermVersionStoreUseCaseInterface {
    func fetchAcceptedTermVersion() -> String
    func setAcceptedTermVersion(_ items: String)
}

public struct AcceptedTermVersionStoreUseCase: AcceptedTermVersionStoreUseCaseInterface {
    private let acceptedTermVersionRepository: AcceptedTermVersionRepositoryInterface

    public init(
        acceptedTermVersionRepository: AcceptedTermVersionRepositoryInterface
    ) {
        self.acceptedTermVersionRepository = acceptedTermVersionRepository
    }

    public func fetchAcceptedTermVersion() -> String {
        return acceptedTermVersionRepository.fetchAcceptedTermVersion()
    }

    public func setAcceptedTermVersion(_ items: String) {
        acceptedTermVersionRepository.setAcceptedTermVersion(items)
    }
}
