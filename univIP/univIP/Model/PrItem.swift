//
//  PrItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/05/09.
//

struct PrItem {
    /// PR画像のURL(IDの代わり)
    public var urlSavedImage: String? = ""
    /// 詳細情報をタップした際に遷移するURL
    public var urlNextTransition: String? = ""
    /// PR画像についての説明
    public var descriptionAboutImage: String? = ""
    /// PR画像掲載者名
    public var requesterName: String? = ""
}
