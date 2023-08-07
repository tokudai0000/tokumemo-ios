//
//  AdItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/05/09.
//

struct AdItem: Decodable {
    let id: String
    let clientName: String
    let imageUrlStr: String
    let targetUrlStr: String
    let imageDescription: String
}
