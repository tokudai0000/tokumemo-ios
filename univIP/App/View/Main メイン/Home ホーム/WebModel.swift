//
//  WebModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/02/19.
//

import Foundation
import Kanna

// MARK: - WebModel
extension HomeViewModel {
    /// タイムアウトのURLであるか判定
    public func isTimeout(urlStr: String) -> Bool {
        return urlStr == Url.universityServiceTimeOut.string() || urlStr == Url.universityServiceTimeOut2.string()
    }
    
    /// JavaScriptを動かしたい指定のURLか判定
    public func canExecuteJS(_ urlString: String) -> Bool {
        // JavaScriptを実行するフラグ
        if dataManager.canExecuteJavascript == false { return false }
        
        // cアカウント、パスワードの登録確認
        if hasRegisteredPassword() == false { return false }
        
        // 大学統合認証システム(IAS)のログイン画面の判定
        if urlString.contains(Url.universityLogin.string()) { return true }
        
        // それ以外なら
        return false
    }
    
    enum flagType {
        case notStart
        case loginStart
        case loginSuccess
        case loginFailure
        case executedJavaScript
    }
    // Dos攻撃を防ぐ為、1度ログインに失敗したら、JavaScriptを動かすフラグを下ろす
    public func updateLoginFlag(type: flagType) {
        
        switch type {
            case .notStart:
                dataManager.canExecuteJavascript = false
                isLoginProcessing = false
                dataManager.isWebLoginCompleted = false
                
            case .loginStart:
                dataManager.canExecuteJavascript = true // ログイン用のJavaScriptを動かす
                isLoginProcessing = true // ログイン処理中
                dataManager.isWebLoginCompleted = false // ログインが完了していない
                
            case .loginSuccess:
                dataManager.canExecuteJavascript = false
                isLoginProcessing = false
                dataManager.isWebLoginCompleted = true
                isLoginCompleteImmediately = true
                lastLoginTime = Date() // 最終ログイン時刻の記録
                
            case .loginFailure:
                dataManager.canExecuteJavascript = false
                isLoginProcessing = false
                dataManager.isWebLoginCompleted = false
                
            case .executedJavaScript:
                // Dos攻撃を防ぐ為、1度ログインに失敗したら、JavaScriptを動かすフラグを下ろす
                dataManager.canExecuteJavascript = false
                isLoginProcessing = true
                dataManager.isWebLoginCompleted = false
        }
    }
    
    /// 大学統合認証システム(IAS)へのログインが完了したか判定
    public func checkLoginComplete(_ urlStr: String) {
        // ログイン後のURL
        let check1 = urlStr.contains(Url.skipReminder.string())
        let check2 = urlStr.contains(Url.courseManagementPC.string())
        let check3 = urlStr.contains(Url.courseManagementMobile.string())
        // 上記から1つでもtrueがあれば、result = true
        let result = check1 || check2 || check3
        
        // ログイン処理中かつ、ログイン後のURL
        if isLoginProcessing, result {
            updateLoginFlag(type: .loginSuccess)
            return
        }
        return
    }
    
    /// 大学統合認証システム(IAS)へのログインが失敗したか判定
    public func isLoginFailure(_ urlStr: String) -> Bool {
        // ログイン失敗した時のURL
        let check1 = urlStr.contains(Url.universityLogin.string())
        let check2 = (urlStr.suffix(2) != "s1")
        // 上記からどちらもtrueであれば、result = true
        let result = check1 && check2
        
        // ログイン処理中かつ、ログイン失敗した時のURL
        if isLoginProcessing, result {
            isLoginProcessing = false
            return true
        }
        return false
    }
    
    /// 大学図書館の種類
    enum LibraryType {
        case main // 常三島本館
        case kura // 蔵本分館
    }
    /// 図書館の開館カレンダーPDFまでのURLRequestを作成する
    ///
    /// PDFへのURLは状況により変化する為、図書館ホームページからスクレイピングを行う
    /// 例1：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021.pdf
    /// 例2：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021_syuusei1.pdf
    /// ==HTML==[常三島(本館Main) , 蔵本(分館Kura)でも同様]
    /// <body class="index">
    ///   <ul>
    ///       <li class="pos_r">
    ///         <a href="pub/pdf/calender/calender_main_2021.pdf title="開館カレンダー">
    ///   ========
    ///   aタグのhref属性を抽出、"pub/pdf/calender/"と一致していれば、例1のURLを作成する。
    /// - Parameter type: 常三島(本館Main) , 蔵本(分館Kura)のどちらの開館カレンダーを欲しいのかLibraryTypeから選択
    /// - Returns: 図書館の開館カレンダーPDFまでのURLRequest
    public func makeLibraryCalendarUrl(type: LibraryType) -> String? {
        var urlString = ""
        switch type {
            case .main:
                urlString = Url.libraryHomePageMainPC.string()
            case .kura:
                urlString = Url.libraryHomePageKuraPC.string()
        }
        let url = URL(string: urlString)! // fatalError
        do {
            // URL先WebページのHTMLデータを取得
            let data = try NSData(contentsOf: url) as Data
            let doc = try HTML(html: data, encoding: String.Encoding.utf8)
            // タグ(HTMLでのリンクの出発点と到達点を指定するタグ)を抽出
            for node in doc.xpath("//a") {
                // 属性(HTMLでの目当ての資源の所在を指し示す属性)に設定されている文字列を出力
                if let str = node["href"] {
                    // 開館カレンダーは図書ホームページのカレンダーボタンにPDFへのURLが埋め込まれている
                    if str.contains("pub/pdf/calender/") {
                        // PDFまでのURLを作成する(本館のURLに付け加える)
                        return Url.libraryHomePageMainPC.string() + str
                    }
                }
            }
            AKLog(level: .ERROR, message: "[URL抽出エラー]: 図書館開館カレンダーURLの抽出エラー \n urlString:\(url.absoluteString)")
        } catch {
            AKLog(level: .ERROR, message: "[Data取得エラー]: 図書館開館カレンダーHTMLデータパースエラー\n urlString:\(url.absoluteString)")
        }
        return nil
    }
    
    /// 今年度の成績表のURLを作成する
    ///
    /// - Note:
    ///   2020年4月〜2021年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2020
    ///   2021年4月〜2022年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2021
    ///   なので、2022年の1月から3月まではURLがyear=2021とする必要あり
    /// - Returns: 今年度の成績表のURL
    public func createCurrentTermPerformanceUrl() -> String {
        
        var year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        
        // 1月から3月までは前年の成績
        if month <= 3 {
            year -= 1
        }
        return Url.currentTermPerformance.string() + String(year)
    }
}

/*
 OpenWeatherMapというサービスを使用
 
 APIのURL
 https://api.openweathermap.org/data/2.5/weather?lat=34.0778755&lon=134.5615651&appid=e0578cd3fb0d436dd64d4d5d5a404f08&lang=ja&units=metric
 
 WeatherIconURL
 https://openweathermap.org/img/wn/02d@2x.png
 
 {
     "coord": {
         "lon": 134.5616,
         "lat": 34.0779
     },
     "weather": [
     {
         "id": 801,
         "main": "Clouds",
         "description": "薄い雲",
         "icon": "02d"
     }
     ],
     "base": "stations",
     "main": {
         "temp": 21.97,
         "feels_like": 21.79,
         "temp_min": 21.97,
         "temp_max": 22.45,
         "pressure": 1013,
         "humidity": 60
     },
     "visibility": 10000,
     "wind": {
         "speed": 2.57,
         "deg": 60
     },
     "clouds": {
        "all": 20
     },
     "dt": 1667456496,
     "sys": {
         "type": 1,
         "id": 8027,
         "country": "JP",
         "sunrise": 1667424156,
         "sunset": 1667462876
     },
     "timezone": 32400,
     "id": 1857689,
     "name": "万代町",
     "cod": 200
 }
 */
