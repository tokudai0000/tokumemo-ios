//
//  NewsListSectionModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Foundation

struct NewsListSectionModel: Hashable {
    let dateText: String
    let items: [NewsListItemModel]
}
