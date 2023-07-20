//
//  PrData.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/05/09.
//

import Foundation

struct PrData {
    /// PR画像のURL(IDの代わりとなる)
    public var imageURL: String? = ""
    /// PR画像の詳細情報をタップした際に遷移する
    public var tappedURL: String? = ""
    /// PR画像についての説明
    public var explanation: String? = ""
    /// PR画像掲載者名
    public var organizationName: String? = ""
}
