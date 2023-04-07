//
//  HomeViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Kanna
import Alamofire
import SwiftyJSON

class SplashViewModel {
    
    // 共通データ・マネージャ
    public let dataManager = DataManager.singleton
    // API マネージャ
    public let apiManager = ApiManager.singleton

    //MARK: - MODEL モデル
    // 宣伝のURL
    struct PublicRelations {
        public var imageURL:String?
        public var introduction:String?
        public var tappedURL:String?
        public var organization_name:String?
        public var description:String?
    }
    public var prItems:[PublicRelations] = []
    public var displayPRImagesNumber: Int? // 表示している広告がadItemsに入っている配列番号
    
    struct Weather {
        public var description: String = ""
        public var feelsLike: String = ""
        public var iconUrlStr: String = ""
    }
    public var weatherData:Weather = Weather()
    
    //MARK: - STATE ステータス
    enum State {
        case weatherBusy  // 準備中
        case weatherReady // 準備完了
        case weatherError // エラー発生

        case prBusy
        case prReady
        case prError
    }
    public var state: ((State) -> Void)?
    
    // MARK: - Public func

    /// 最新の利用規約同意者か判定し、同意画面の表示を行うべきか判定
    public func isTermsOfServiceAgreementNeeded() -> Bool {
        return dataManager.agreementVersion != ConstStruct.latestTermsVersion
    }
    
    // 学生番号、パスワードを登録しているか判定
    public func hasRegisteredPassword() -> Bool {
        return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty)
    }
    
    // GitHub上に0-2までのpngがある場合、ここでは
    // 0.png -> 1.png -> 2.png -> 0.png とローテーションする
    // その判定を3.pngをデータ化した際エラーが出ると、3.pngが存在しないと判定し、0.pngを読み込ませる　PR画像
    public func getPRItems() {
        prItems.removeAll()
        
        let urlStr = "https://tokudai0000.github.io/tokumemo_resource/pr_image/info.json"
        
        apiManager.request(urlStr,
                           success: { [weak self] (response) in
            
            guard let self = self else { // HomeViewModelのself
                AKLog(level: .FATAL, message: "[self] FatalError")
                fatalError()
            }
            let itemCounts = response["itemCounts"].int ?? 0
            
            for i in 0 ..< itemCounts {
                let item = response["items"][i]
                let prItem = PublicRelations(imageURL: item["imageURL"].string,
                                           introduction: item["introduction"].string,
                                           tappedURL: item["tappedURL"].string,
                                           organization_name: item["organization_name"].string,
                                           description: item["description"].string)
                self.prItems.append(prItem)
            }
            self.state?(.prReady) // 通信完了
            
        }, failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
            self?.state?(.prError) // エラー表示
        })
    }
    
    public func selectPRImageNumber() -> Int? {
        // 広告数が0か1の場合はローテーションする必要がない
        if prItems.count == 0 {
            return nil
        } else if prItems.count == 1 {
            return 0
        }
        
        while true {
            let randomNum = Int.random(in: 0..<prItems.count)
            // 前回の画像表示番号と同じであれば、再度繰り返す
            if randomNum != displayPRImagesNumber {
                return randomNum
            }
        }
        
    }
    
    // OpenWeatherMapのAPIから天気情報を取得
    public func getWether() {
        let latitude = "34.0778755" // 緯度 (徳島大学の座標)
        let longitude = "134.5615651" // 経度
        let API_KEY = loadPlist(path: "key", key: "openWeatherMapAPIKey")
        let parameter = "lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)&lang=ja&units=metric"
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?" + parameter
        
        state?(.weatherBusy) // 通信開始（通信中）
        apiManager.request(urlStr,
                           success: { [weak self] (response) in
            
            guard let self = self else { // HomeViewModelのself
                AKLog(level: .FATAL, message: "[self] FatalError")
                fatalError()
            }
            
            // 天気の様子が返ってくる 例: 曇
            self.weatherData.description = response["weather"][0]["description"].string ?? "Error"
            
            // 気温がdoubleの形で返ってくる　例: 21.52
            if let temp = response["main"]["temp"].double {
                // 215.2を四捨五入 => 215 , 215/10 = 21.5
                let num = round(temp * 10) / 10
                self.weatherData.feelsLike = String(num) + "℃" // 例: "21.5℃"
            }
            
            // 天気を表すアイコンコードが返ってくる 例 "02d"
            if let iconCode = response["weather"][0]["icon"].string {
                let urlStr = "https://openweathermap.org/img/wn/" + iconCode + "@2x.png"
                self.weatherData.iconUrlStr = urlStr
            }
            self.state?(.weatherReady) // 通信完了
            
        }, failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
            self?.state?(.weatherError) // エラー表示
        })
    }
    
    public var lastLoginTime = Date().secondBefore(500)
    public func isWebLoginRequired() -> Bool {
        // パスワード更新等をした時に再ログイン
        if dataManager.shouldRelogin {
            dataManager.shouldRelogin = false
            return true
        }
        let distance = abs(lastLoginTime.timeIntervalSinceNow)
        // 300秒 = 5分
        return 300 < distance
    }
    
    /// TableCellの内容(isHiddon=trueを除く)
    public var menuLists: [MenuListItem] {
        get{
            // コレクションビューに表示させる配列(ここに入れていく)
            var displayLists:[MenuListItem] = []
            
            for item in dataManager.menuLists {
                if !item.isHiddon {
                    displayLists.append(item)
                }
            }
            return displayLists
        }
    }
    

    // MARK: - Private func
    // GitHubからtxtデータを取得する
    private func getTxtDataFromGitHub(url: URL) -> String? {
        do {
            // URL先WebページのHTMLデータを取得
            let data = try NSData(contentsOf: url) as Data
            let doc = try HTML(html: data, encoding: String.Encoding.utf8)
            if let tx = doc.body?.text {
                return tx
            }
            AKLog(level: .ERROR, message: "txtファイル内にデータなし")
            return nil
        } catch {
            AKLog(level: .ERROR, message: "txtファイル存在せず")
            return nil
        }
    }
    
    /// plistを読み込み
    private func loadPlist(path: String, key: String) -> String{
        let filePath = Bundle.main.path(forResource: path, ofType:"plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        
        guard let pl = plist else{
            AKLog(level: .ERROR, message: "plistが存在しません")
            return ""
        }
        return pl[key] as! String
    }
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
                dataManager.loginState.isProgress = false
                dataManager.loginState.completed = false
                
            case .loginStart:
                dataManager.canExecuteJavascript = true // ログイン用のJavaScriptを動かす
                dataManager.loginState.isProgress = true // ログイン処理中
                dataManager.loginState.completed = false // ログインが完了していない
                
            case .loginSuccess:
                dataManager.canExecuteJavascript = false
                dataManager.loginState.isProgress = false
                dataManager.loginState.completeImmediately = true
                dataManager.loginState.completed = true
                lastLoginTime = Date() // 最終ログイン時刻の記録
                
            case .loginFailure:
                dataManager.canExecuteJavascript = false
                dataManager.loginState.isProgress = false
                dataManager.loginState.completed = false
                
            case .executedJavaScript:
                // Dos攻撃を防ぐ為、1度ログインに失敗したら、JavaScriptを動かすフラグを下ろす
                dataManager.canExecuteJavascript = false
                dataManager.loginState.isProgress = true
                dataManager.loginState.completed = false
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
        if dataManager.loginState.isProgress, result {
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
        if dataManager.loginState.isProgress, result {
            dataManager.loginState.isProgress = false
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
