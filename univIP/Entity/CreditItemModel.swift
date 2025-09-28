//
//  AcknowledgementsItemModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

struct CreditItemModel: Equatable {
    let title: String
    let license: String
    let contentsText: String

    init(title: String, license: String, contentsText: String) {
        self.title = title
        self.license = license
        self.contentsText = contentsText
    }
}
