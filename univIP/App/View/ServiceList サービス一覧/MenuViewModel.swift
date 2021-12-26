//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation

final class MenuViewModel {
    
    private let dataManager = DataManager.singleton
    
    
    // MARK: public
    
    /// 今年度の成績表のURLを作成する
    /// - Returns: 今年度の成績表のURL
    public func createCurrentTermPerformanceUrl() -> URLRequest? {
        // 2020年4月〜2021年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2020
        // 2021年4月〜2022年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2021
        
        var year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        
        // 1月から3月までは前年の成績
        if month <= 3 {
            year -= 1
        }
        
        let urlString = Url.currentTermPerformance.string() + String(year)
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
            
        } else {
            AKLog(level: .ERROR, message: "[URLフォーマットエラー]: 今年度の成績表URL生成エラー urlString:\(urlString)")
            return nil
        }
    }
    
}
