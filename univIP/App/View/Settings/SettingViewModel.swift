//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

import UIKit

class SettingViewModel: NSObject {
    
    var sectionHight:Int = 2
    var cellHight:Int = 44
    var allCellList:[[CellList]] =  [[],
                                             [CellList(id:100, name: "パスワード設定", category: "", display: true),
                                              CellList(id:101, name: "このアプリについて", category: "", display: true),
                                              CellList(id:102, name: "開発者へ連絡", category: "", display: true)]]
    var cellList:[CellList] = []
    let cellKey = "CellKey"
    var editSituation = true
    
    func saveCellList(lists:[CellList]){
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(lists) else {
            return
        }
        UserDefaults.standard.set(data, forKey: cellKey)
    }
    
    func loadCellList() -> [CellList] {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: cellKey),
              let bookmarks = try? jsonDecoder.decode([CellList].self, from: data) else {
            return cellList
        }
            
        return bookmarks
    }
}
