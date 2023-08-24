//
//  MenuItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

import Foundation

public struct MenuItem {
    public enum type {
        case courseManagement
        case manaba
        case mail
        case academicRelated
        case libraryRelated
        case etc
    }

    public let title: String
    public let id: type
    public let icon: String
    public let targetUrl: URLRequest?

    public init(title: String, id: type, icon: String, targetUrl: URLRequest?) {
        self.title = title
        self.id = id
        self.icon = icon
        self.targetUrl = targetUrl
    }
}
