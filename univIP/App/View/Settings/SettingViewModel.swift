//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

import UIKit

final class SettingViewModel: NSObject {
    
    private let model = Model()
    
    var sectionHight:Int = 15
    var cellHight:Int = 44
    
    var allCellList:[[CellList]] =  [[], []]
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
    
    /// バージョンID
    private let KEY_versionId = "KEY_versionId"
    func firstBootDecision() {
    
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let lastTimeVersion = UserDefaults.standard.string(forKey: KEY_versionId)
        
        // アップデート直後か判定する
        if lastTimeVersion != version {
            var serviceL:[CellList] = []      // 並び順などを反映するリスト
            
            if lastTimeVersion == nil { // 初回
                allCellList[0].append(contentsOf: model.serviceCellLists)
                allCellList[1].append(contentsOf: model.settingCellLists)
                
            } else {
                let lastL = loadCellList()        // 前回のリスト
                var newL = model.serviceCellLists // 新しいリスト
                
                for item in lastL {
                    serviceL.append(contentsOf: newL[item.id])
                }
                for i in 0 ..< lastL.count {
                    
                    if //lastL.count <= i {         // 新しい機能は新規追加
                        serviceL.append(newL[i])
                        
                    }else{
                        newL[lastL[i].id].display = lastL[i].display
                        serviceL.append(newL[lastL[i].id])
                    }
                }
                allCellList[0].append(contentsOf: serviceL)
                allCellList[1].append(contentsOf: model.settingCellLists)
            }
            
            
            UserDefaults.standard.set(version, forKey: KEY_versionId) // 更新
            

            print(cellList)
            saveCellList(lists: cellList)
        }
    }
}
