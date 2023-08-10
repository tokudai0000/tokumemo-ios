//
//  HomeMiniSettingsItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation

struct HomeMiniSettingsItem {
    enum type {
        case prApplication
        case contactUs
        case homePage
        case termsOfService
        case privacyPolicy
    }

    public let title: String
    public let id: type
    public let targetUrl: URLRequest?
}
