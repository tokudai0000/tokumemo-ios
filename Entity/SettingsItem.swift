//
//  SettingsItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

import Foundation

public struct SettingsItem {
    public enum type {
        case password
        case aboutThisApp
        case contactUs
        case officialSNS
        case homePage
        case termsOfService
        case privacyPolicy
        case sourceCode
        case review
        case acknowledgements
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
