//
//  MenuItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

import UIKit

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
    public let icon: UIImage?
    public let targetUrl: URLRequest?

    public init(title: String, id: type, icon: UIImage?, targetUrl: URLRequest?) {
        self.title = title
        self.id = id
        self.icon = icon
        self.targetUrl = targetUrl
    }
}
