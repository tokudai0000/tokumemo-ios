//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

import UIKit

class SettingViewModel: NSObject {
//    var cellList:[CellList] = [CellList(id:0, name: "Webサイト", category: "図書館", display: true),
//                               CellList(id:1, name: "貸し出し期間延長", category: "図書館", display: true),
//                               CellList(id:2, name: "本購入リクエスト", category: "図書館", display: true),
//                               CellList(id:3, name: "開館カレンダー", category: "図書館", display: true),
//                               CellList(id:4, name: "シラバス", category: "シラバス", display: true),
//                               CellList(id:5, name: "時間割", category: "教務事務システム", display: true),
//                               CellList(id:6, name: "今年の成績表", category: "教務事務システム", display: true),
//                               CellList(id:7, name: "成績参照", category: "教務事務システム", display: true),
//                               CellList(id:8, name: "出欠記録", category: "教務事務システム", display: true),
//                               CellList(id:9, name: "授業アンケート", category: "教務事務システム", display: true),
//                               CellList(id:10, name: "メール", category: "Outlook", display: true),
//                               CellList(id:11, name: "マナバPC版", category: "manaba", display: true),
//                               CellList(id:12, name: "キャリア支援室", category: "就職活動", display: true),
//                               CellList(id:13, name: "履修登録", category: "教務事務システム", display: true)]
    
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
