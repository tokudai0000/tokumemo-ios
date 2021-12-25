//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

import Foundation

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
    
}
