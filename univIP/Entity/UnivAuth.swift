//
//  UnivAuth.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/19.
//

struct UnivAuth {
    let accountCID: String
    let password: String
    
    init(accountCID: String, password: String) {
        self.accountCID = accountCID
        self.password = password
    }
}
