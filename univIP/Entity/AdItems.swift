//
//  AdItems.swift
//  Entity
//
//  Created by Akihiro Matsuyama on 2023/08/24.
//

struct AdItems {
    var prItems:[AdItem]
    var univItems:[AdItem]

    init(prItems: [AdItem], univItems: [AdItem]) {
        self.prItems = prItems
        self.univItems = univItems
    }
}
