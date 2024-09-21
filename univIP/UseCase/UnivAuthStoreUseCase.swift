//
//  PasswordStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation

protocol UnivAuthStoreUseCaseInterface {
    func fetchUnivAuth() -> UnivAuth
    func setUnivAuth(_ items: UnivAuth)
}

struct UnivAuthStoreUseCase: UnivAuthStoreUseCaseInterface {
    private let univAuthRepository: UnivAuthRepositoryInterface
    
    init(
        univAuthRepository: UnivAuthRepositoryInterface
    ) {
        self.univAuthRepository = univAuthRepository
    }
    
    func fetchUnivAuth() -> UnivAuth {
        return univAuthRepository.fetchUnivAuth()
    }
    
    func setUnivAuth(_ items: UnivAuth) {
        univAuthRepository.setUnivAuth(items)
    }
}
