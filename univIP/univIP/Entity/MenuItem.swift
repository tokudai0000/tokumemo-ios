//
//  MenuItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

import Foundation

struct MenuItem {
    enum type {
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
}
