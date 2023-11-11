//
//  HomeMiniSettingsItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

import Foundation

public struct HomeMiniSettingsItem {
    public enum type {
        case review
        case prApplication
        case contactUs
        case homePage
        case termsOfService
        case privacyPolicy
    }

    public let title: String
    public let id: type
    public let targetUrl: URLRequest?

    public init(title: String, id: type, targetUrl: URLRequest?) {
        self.title = title
        self.id = id
        self.targetUrl = targetUrl
    }
}
