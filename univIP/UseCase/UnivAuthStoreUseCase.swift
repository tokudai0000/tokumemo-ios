//
//  PasswordStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation

public protocol UnivAuthStoreUseCaseInterface {
    func fetchUnivAuth() -> UnivAuth
    func setUnivAuth(_ items: UnivAuth)
}

public struct UnivAuthStoreUseCase: UnivAuthStoreUseCaseInterface {
    private let univAuthRepository: UnivAuthRepositoryInterface

    public init(
        univAuthRepository: UnivAuthRepositoryInterface
    ) {
        self.univAuthRepository = univAuthRepository
    }

    public func fetchUnivAuth() -> UnivAuth {
        return univAuthRepository.fetchUnivAuth()
    }

    public func setUnivAuth(_ items: UnivAuth) {
        univAuthRepository.setUnivAuth(items)
    }
}
