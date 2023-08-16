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

    let title: String
    let id: type
    let icon: String
    let targetUrl: URLRequest?
}
