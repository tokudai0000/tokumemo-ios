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
