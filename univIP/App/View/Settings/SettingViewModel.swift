//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

import UIKit

final class SettingViewModel: NSObject {
    
    private let model = Model()
    
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
    
    func firstBootDecision() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let versionKey = "ver_" + version
        // 保存されたデータがversionいつの物か判定
        print(UserDefaults.standard.string(forKey: "VersionKey"))
        if UserDefaults.standard.string(forKey: "VersionKey") != versionKey{
            UserDefaults.standard.set(versionKey, forKey: "VersionKey") // 更新
            
            let legacyCellLists = loadCellList()
            var newCellLists = model.cellList
            
            for i in 0 ..< newCellLists.count{
                if legacyCellLists.count <= i{
                    cellList.append(newCellLists[i])
                }else{
                    newCellLists[legacyCellLists[i].id].display = legacyCellLists[i].display
                    cellList.append(newCellLists[legacyCellLists[i].id])
                }
            }
            print(cellList)
            saveCellList(lists: cellList)
        }
    }
}
