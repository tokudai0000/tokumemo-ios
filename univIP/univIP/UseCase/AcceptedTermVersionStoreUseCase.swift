//
//  AcceptedTermVersionStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/16.
//

import Foundation

protocol AcceptedTermVersionStoreUseCaseInterface {
    func fetchAcceptedTermVersion() -> String
    func setAcceptedTermVersion(_ items: String)
}

struct AcceptedTermVersionStoreUseCase: AcceptedTermVersionStoreUseCaseInterface {
    private let acceptedTermVersionRepository: AcceptedTermVersionRepositoryInterface

    init(
        acceptedTermVersionRepository: AcceptedTermVersionRepositoryInterface
    ) {
        self.acceptedTermVersionRepository = acceptedTermVersionRepository
    }

    func fetchAcceptedTermVersion() -> String {
        return acceptedTermVersionRepository.fetchAcceptedTermVersion()
    }

    func setAcceptedTermVersion(_ items: String) {
        acceptedTermVersionRepository.setAcceptedTermVersion(items)
    }
}
