//
//  UnivAuth.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/19.
//

public struct UnivAuth {
    public let accountCID: String
    public let password: String

    public init(accountCID: String, password: String) {
        self.accountCID = accountCID
        self.password = password
    }
}
