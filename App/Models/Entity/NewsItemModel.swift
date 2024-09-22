//
//  NewsItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

struct NewsItemModel {
    let title: String
    let targetUrlStr: String
    let createdAt: String
    
    init(title: String, targetUrlStr: String, createdAt: String) {
        self.title = title
        self.targetUrlStr = targetUrlStr
        self.createdAt = createdAt
    }
}
