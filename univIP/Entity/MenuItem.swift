//
//  MenuItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

import UIKit

struct MenuItem {
    enum type {
        case courseManagement
        case manaba
        case mail
        case academicRelated
        case libraryRelated
        case etc
    }

    let title: String
    let id: type
    let icon: UIImage?
    let targetUrl: URLRequest?

    init(title: String, id: type, icon: UIImage?, targetUrl: URLRequest?) {
        self.title = title
        self.id = id
        self.icon = icon
        self.targetUrl = targetUrl
    }
}
