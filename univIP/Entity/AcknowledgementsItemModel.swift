//
//  AcknowledgementsItemModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

public struct AcknowledgementsItemModel {
    public let title: String
    public let license: String
    public let contentsText: String

    public init(title: String, license: String, contentsText: String) {
        self.title = title
        self.license = license
        self.contentsText = contentsText
    }
}
