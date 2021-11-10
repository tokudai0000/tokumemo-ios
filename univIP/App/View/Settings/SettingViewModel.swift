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
    var dataManager = DataManager.singleton
//    var allCellList:[[CellList]] =  [[], []]
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
    
        var serviceL:[CellList] = []      // 並び順などを反映するcell
                
        // アプリ起動後、初回の表示か判定
        if dataManager.allCellList[0].isEmpty {
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String // 今のバージョン
            let lastTimeVersion = UserDefaults.standard.string(forKey: KEY_versionId)                       // 前回ログイン時のバージョン
            UserDefaults.standard.set(version, forKey: KEY_versionId)                                       // 更新
            
            // 初回の利用者か判定
            if lastTimeVersion == nil {
                dataManager.allCellList[0].append(contentsOf: model.serviceCellLists)
                dataManager.allCellList[1].append(contentsOf: model.settingCellLists)
                saveCellList(lists: dataManager.allCellList[0])
                return
            }
            
            // アップデート後、初回の表示か判定
            if lastTimeVersion != version {
                // cellの内容を更新する
                let lastL = loadCellList()        // 前回のcell
                var newL = model.serviceCellLists // 新しいcell
                
                for item in lastL {
                    // 前回のcellのidで新しいcellのidを検索（ユーザーが指定した並び順を更新しても保持できる）
                    // 前回のcellのdisplayを検索した新しいcellへ引き継ぎ
                    // 引き継ぎした内容をserviceLに追加後、newLから削除することで新規機能をまとめて追加できる
                    if let userIndex = newL.firstIndex(where: {$0.id == item.id}) {
                        var edit = newL[userIndex]
                        edit.display = item.display
                        serviceL.append(edit)
                        newL.remove(at: userIndex)
                    }
                    // elseには前回にはあったが、今回削除された機能の場合追加しないように通る
                }
                serviceL.append(contentsOf: newL)
            
                dataManager.allCellList[0].append(contentsOf: serviceL)
                
            } else {
                dataManager.allCellList[0].append(contentsOf: loadCellList())

            }
            saveCellList(lists: dataManager.allCellList[0])
            dataManager.allCellList[1].append(contentsOf: model.settingCellLists)
        }
        
    }
}
