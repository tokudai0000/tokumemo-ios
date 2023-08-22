//
//  SettingsItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

import Foundation

struct SettingsItem {
    enum type {
        case password
        case aboutThisApp
        case contactUs
        case officialSNS
        case homePage
        case termsOfService
        case privacyPolicy
        case sourceCode
        case acknowledgements
    }

    let title: String
    let id: type
    let targetUrl: URLRequest?
}
