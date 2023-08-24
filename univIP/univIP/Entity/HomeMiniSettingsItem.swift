//
//  HomeMiniSettingsItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation

struct HomeMiniSettingsItem {
    enum type {
        case review
        case prApplication
        case contactUs
        case homePage
        case termsOfService
        case privacyPolicy
    }

    let title: String
    let id: type
    let targetUrl: URLRequest?
}
