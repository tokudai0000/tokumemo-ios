//
//  AdItems.swift
//  Entity
//
//  Created by Akihiro Matsuyama on 2023/08/24.
//

public struct AdItems {
    public var prItems:[AdItem]
    public var univItems:[AdItem]

    public init(prItems: [AdItem], univItems: [AdItem]) {
        self.prItems = prItems
        self.univItems = univItems
    }
}
