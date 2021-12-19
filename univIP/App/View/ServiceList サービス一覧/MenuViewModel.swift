//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

import Foundation
import Kanna

final class MenuViewModel {
    
    private let dataManager = DataManager.singleton
    
    
    // MARK: public
    public func initialBootProcess() {
        
        // 2回目以降は、読み込む必要がない
        if !dataManager.menuLists[0].isEmpty {
            return
        }
        
        var modelLists = Constant.initServiceLists
        let savingLists = dataManager.serviceLists
        var updateForLists:[Constant.Menu] = []
        
        if savingLists.isEmpty {
            dataManager.menuLists[0].append(contentsOf: Constant.initServiceLists)
            dataManager.menuLists[1].append(contentsOf: Constant.initSettingLists)
            dataManager.serviceLists = dataManager.menuLists[0]
            return
        }
        
        /// 並び順、名前、表示　を引き継ぐ
        for oldList in savingLists { // 並び順を保持する
            if let index = modelLists.firstIndex(where: {$0.type == oldList.type}) {
                modelLists[index].title = oldList.title             // ユーザーが指定した名前
                modelLists[index].isDisplay = oldList.isDisplay     // ユーザーが指定した表示
                modelLists[index].initialView = oldList.initialView // ユーザーが指定した初期画面
                updateForLists.append(modelLists[index])
                modelLists.remove(at: index)
            }
        }
        
        // 新規実装があれば通る
        updateForLists.append(contentsOf: modelLists)
        
        dataManager.menuLists[0].append(contentsOf: updateForLists)
        dataManager.menuLists[1].append(contentsOf: Constant.initSettingLists)
        dataManager.serviceLists = dataManager.menuLists[0]
    }
    
    public func createCurrentTermPerformanceUrl() -> URLRequest {
        var year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        
        // 1月から3月までは前年の成績
        if (month <= 3){
            year -= 1
        }
        
        let urlString = Url.currentTermPerformance.string() + String(year)
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        } else {
            AKLog(level: .FATAL, message: "URLフォーマットエラー")
            fatalError()
        }
    }
    
    public func fetchLibraryCalenderUrl(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        let data = NSData(contentsOf: url as URL)
        
        do {
            // MARK: - HACK 汚い
            let doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
            for node in doc.xpath("//a") {
                guard let str = node["href"] else {
                    return nil
                }
                if str.contains("pub/pdf/calender/calender") {
                    let urlString = "https://www.lib.tokushima-u.ac.jp/" + node["href"]!
                    if let url = URL(string: urlString) {
                        return URLRequest(url: url)
                        
                    } else {
                        AKLog(level: .FATAL, message: "URLフォーマットエラー")
                        fatalError()
                    }
                }
            }
            return nil
        } catch {
            return nil
        }
    }
}
