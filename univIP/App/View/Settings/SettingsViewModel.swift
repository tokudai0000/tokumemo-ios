//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

import Foundation

final class SettingViewModel: NSObject {
    
    public let sectionHight:Int = 15
    public let cellHight:Int = 44
    public var editSituation = true
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    
    
    /// セルID
    public func saveCellList(lists:[CellList]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(lists) else { return }
        dataManager.settingCellList = data
    }
    
    public func loadCellList() -> [CellList] {
        let jsonDecoder = JSONDecoder()
        let data = dataManager.settingCellList
        guard let bookmarks = try? jsonDecoder.decode([CellList].self, from: data) else { return [] }
        return bookmarks
    }
    

    // MARK: - Question 分たい
    public func firstBootDecision() {
        // 並び順などを反映するcell
        var serviceL:[CellList] = []
                
        // アプリ起動後、初回の表示か判定
        if dataManager.allCellList[0].isEmpty {
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String // 今のバージョン
            let lastTimeVersion = dataManager.version
            
            if dataManager.isFirstTime {
                // 初回の利用者か判定
                dataManager.allCellList[0].append(contentsOf: model.serviceCellLists)
                
            } else {
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
                            edit.isDisplay = item.isDisplay
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
            }
            saveCellList(lists: dataManager.allCellList[0])
            dataManager.allCellList[1].append(contentsOf: model.settingCellLists)
            
            dataManager.version = version          // 更新
        }
    }
}
