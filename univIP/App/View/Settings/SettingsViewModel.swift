//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

import Foundation
import Kanna

final class SettingViewModel {
    
    public var editSituation = true
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    

    // MARK: public
    public func firstBootDecision() {
        // 並び順などを反映するcell
        var reflectedLists:[CellList] = []
                
        // アプリ起動後、初回の表示か判定
        if dataManager.allCellList[0].isEmpty {
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String // 今のバージョン
            let lastTimeVersion = dataManager.version
            
            if dataManager.isFirstTime { // 初回の利用者か判定
                dataManager.allCellList[0].append(contentsOf: model.serviceCellLists)
                
            } else if lastTimeVersion != version { // アップデート後、初回の表示か判定
                
                // cellの内容を更新する
                let oldLists = dataManager.settingCellList    // 前回のcell
                var latestLists = model.serviceCellLists      // 新しいcell
                
                // 前回のcellのidで新しいcellのidを検索（ユーザーが指定した並び順を更新しても保持できる）
                // 前回のcellのdisplayを検索した新しいcellへ引き継ぎ
                // 引き継ぎした内容をserviceLに追加後、newLから削除することで新規機能をまとめて追加できる
                for item in oldLists { // ユーザーが設定した並び順を尊重
                    
                    if let userIndex = latestLists.firstIndex(where: {$0.type == item.type}) {
                        latestLists[userIndex].title = item.title         // ユーザーが指定した名前
                        latestLists[userIndex].isDisplay = item.isDisplay // ユーザーが指定した表示
                        reflectedLists.append(latestLists[userIndex])
                        latestLists.remove(at: userIndex)
                    }
                    // elseには前回にはあったが、今回削除された機能の場合追加しないように通る
                }
                // 新規機能を追加
                reflectedLists.append(contentsOf: latestLists)
                
                dataManager.allCellList[0].append(contentsOf: reflectedLists)
                
            } else {
                dataManager.allCellList[0].append(contentsOf: dataManager.settingCellList)
                
                
                
            }
            
            dataManager.settingCellList = dataManager.allCellList[0]
            dataManager.allCellList[1].append(contentsOf: model.settingCellLists)
            dataManager.version = version          // 更新
        }
    }
    
    public func getCurrentTermPerformance() -> URLRequest {
        let current = Calendar.current
        var year = current.component(.year, from: Date())
        let month = current.component(.month, from: Date())
        
        if (month <= 3){ // 1月から3月までは前年の成績であるから
            year -= 1
        }
        let termPerformanceYearURL = Url.currentTermPerformance.string() + String(year)
        if let url = URL(string: termPerformanceYearURL) {
            return URLRequest(url: url)
            
        } else {
            // エラー処理
            AKLog(level: .FATAL, message: "URLフォーマットエラー")
            fatalError() // 予期しないため、強制的にアプリを落とす
        }
    }
    
    public func getLibraryCalenderUrl() -> URLRequest? {
        let url = NSURL(string: Url.libraryHome.string())
        let data = NSData(contentsOf: url! as URL)
        
        var calenderURL = ""
        
        do {
            let doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
            for node in doc.xpath("//a") {
                guard let str = node["href"] else {
                    return nil
                }
                if str.contains("pub/pdf/calender/calender_main_"){
                    calenderURL = "https://www.lib.tokushima-u.ac.jp/" + node["href"]!
                    if let url = URL(string: calenderURL) {
                        return URLRequest(url: url)
                        
                    } else {
                        // エラー処理
                        AKLog(level: .FATAL, message: "URLフォーマットエラー")
                        fatalError() // 予期しないため、強制的にアプリを落とす
                    }
                }
            }
            return nil
            
        } catch {
            return nil
        }
    }
}
