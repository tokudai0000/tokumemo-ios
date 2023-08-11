//
//  PasswordStoreUseCase.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation
import UIKit

protocol PasswordStoreUseCaseInterface {
    func fetchCAccount() -> String
    func fetchPassword() -> String

    func assignmentCAccount(_ items: String)
    func assignmentPassword(_ items: String)
}

struct PasswordStoreUseCase: PasswordStoreUseCaseInterface {
    private let passwordRepository: PasswordRepositoryInterface

    init(
        passwordRepository: PasswordRepositoryInterface
    ) {
        self.passwordRepository = passwordRepository
    }

    func fetchCAccount() -> String {
        return passwordRepository.fetchCAccount()
    }

    func fetchPassword() -> String {
        return passwordRepository.fetchPassword()
    }

    func assignmentCAccount(_ items: String) {
        passwordRepository.assignmentCACount(items)
    }

    func assignmentPassword(_ items: String) {
        passwordRepository.assignmentPassword(items)
    }
}
