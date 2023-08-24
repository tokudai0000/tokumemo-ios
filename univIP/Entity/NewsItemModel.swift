//
//  NewsItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

public struct NewsItemModel {
    public let title: String
    public let targetUrlStr: String
    public let createdAt: String
    
    public init(title: String, targetUrlStr: String, createdAt: String) {
        self.title = title
        self.targetUrlStr = targetUrlStr
        self.createdAt = createdAt
    }
}
