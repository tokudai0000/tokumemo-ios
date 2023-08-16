//
//  PasswordStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation

protocol PasswordStoreUseCaseInterface {
    func fetchAccountID() -> String
    func fetchPassword() -> String

    func setAccountID(_ items: String)
    func setPassword(_ items: String)
}

struct PasswordStoreUseCase: PasswordStoreUseCaseInterface {
    private let passwordRepository: PasswordRepositoryInterface

    init(
        passwordRepository: PasswordRepositoryInterface
    ) {
        self.passwordRepository = passwordRepository
    }

    func fetchAccountID() -> String {
        return passwordRepository.fetchAccountID()
    }

    func fetchPassword() -> String {
        return passwordRepository.fetchPassword()
    }

    func setAccountID(_ items: String) {
        passwordRepository.setAccountID(items)
    }

    func setPassword(_ items: String) {
        passwordRepository.setPassword(items)
    }
}
