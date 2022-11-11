//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Kanna
import Alamofire
import SwiftyJSON

final class HomeViewModel {
    
    // MARK: - Private
    private let dataManager = DataManager.singleton
    private let apiManager = ApiManager.singleton
    
    // cアカウント、パスワードを登録しているか判定 (読み取り専用)
    private var hasRegisteredPassword: Bool { get { return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty) }}
    
    
    // MARK: - Public
    /// TableCellの内容
    public var collectionLists:[Constant.CollectionCell] = Constant.initCustomCellLists
    
    public var isLoginProcessing = false // ログイン処理中
    public var isLoginComplete = false // ログイン完了
    public var isLoginCompleteImmediately = false // ログイン完了後すぐ
    
    public var weatherDataDiscription = ""
    public var weatherDataFeelLike = ""
    public var weatherDataIconUrlStr = ""
    
    
    /// 最新の利用規約同意者か判定し、同意画面の表示を行うべきか判定　(読み取り専用)
    public var shouldShowTermsAgreementView: Bool {
        get { return dataManager.agreementVersion != Constant.latestTermsVersion }
    }
    
    /// タイムアウトのURLであるかどうかの判定
    /// - Parameter urlString: 読み込み完了したURLの文字列
    /// - Returns: 結果
    public func shouldReLogin(_ url: String) -> Bool {
        return url == Url.universityServiceTimeOut.string() || url == Url.universityServiceTimeOut2.string()
    }
    

    /// JavaScriptを動かしたい指定のURLかどうかを判定し可能ならTrueを返す
    ///
    /// - Note: canExecuteJavascriptが重要な理由
    ///   ログインに失敗した場合に再度ログインのURLが表示されることになる。
    ///   canExecuteJavascriptが存在しないと、再度ログインの為にJavaScriptが実行され続け無限ループとなってしまう。
    /// - Parameter urlString: 読み込み完了したURLの文字列
    /// - Returns: 動かせるかどうか
    public func canJavaScriptExecute(_ urlString: String) -> Bool {
        // JavaScriptを実行するフラグが立っていない場合はnoneを返す
        if dataManager.canExecuteJavascript == false {
            return false
        }
        // cアカウント、パスワードを登録しているか
        if hasRegisteredPassword == false {
            return false
        }
        // 大学統合認証システム(IAS)のログイン画面
        if urlString.contains(Url.universityLogin.string()) {
            return true
        }
        // それ以外なら
        return false
    }
    
    /// 大学統合認証システム(IAS)へのログインが完了したかどうか
    ///
    /// 以下2つの状態なら完了とする
    ///  1. ログイン後のURLが指定したURLと一致していること
    ///  2. ログイン処理中であるフラグが立っていること
    ///  認められない場合は、falseとする
    /// - Note:
    /// - Parameter urlString: 現在表示しているURLString
    /// - Returns: 判定結果、許可ならtrue
    public func isLoggedin(_ urlString: String) -> Bool {
        // ログイン後のURLが指定したURLと一致しているかどうか
        let check1 = urlString.contains(Url.skipReminder.string())
        let check2 = urlString.contains(Url.courseManagementPC.string())
        let check3 = urlString.contains(Url.courseManagementMobile.string())
        // 上記から1つでもtrueがあれば、引き継ぐ
        let result = check1 || check2 || check3
        // ログイン処理中かつ、ログインURLと異なっている場合(URLが同じ場合はログイン失敗した状態)
        if isLoginProcessing, result {
            // ログインプロセスは終了
            isLoginProcessing = false
            isLoginCompleteImmediately = true
            return true
        }
        // ログイン完了後に別画面開いてもtrueになるように
        return isLoginComplete
    }
    
    public func isMissLoggedin(_ urlString: String) -> Bool {
        let check1 = urlString.contains(Url.universityLogin.string())
        let check2 = (urlString.suffix(2) != "s1")
        if isLoginProcessing, check1, check2 {
            // ログインプロセスは終了
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
            let data = NSData(contentsOf: url as URL)! as Data
            let doc = try HTML(html: data, encoding: String.Encoding.utf8)
            // aタグ(HTMLでのリンクの出発点と到達点を指定するタグ)を抽出
            for node in doc.xpath("//a") {
                // href属性(HTMLでの目当ての資源の所在を指し示す属性)に設定されている文字列を出力
                guard let str = node["href"] else {
                    AKLog(level: .ERROR, message: "[href属性出力エラー]: href属性に設定されている文字列を出力する際のエラー")
                    return nil
                }
                // 開館カレンダーは図書ホームページのカレンダーボタンにPDFへのURLが埋め込まれている
                if str.contains("pub/pdf/calender/") {
                    // PDFまでのURLを作成する(本館のURLに付け加える)
                    return Url.libraryHomePageMainPC.string() + str
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
    
    
    //MARK: - STATE ステータス
    enum State {
        case busy           // 準備中
        case ready          // 準備完了
        case error          // エラー発生
    }
    public var state: ((State) -> Void)?
    
    /*
     OpenWeatherMapというサービスを使用
     
     APIのURL
     https://api.openweathermap.org/data/2.5/weather?lat=34.0778755&lon=134.5615651&appid=e0578cd3fb0d436dd64d4d5d5a404f08&lang=ja&units=metric
     
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
    
    public func getWetherData() {
        state?(.busy) // 通信開始（通信中）
        
        let latitude = "34.0778755" // 緯度 (徳島大学の座標)
        let longitude = "134.5615651" // 経度
        let API_KEY = "e0578cd3fb0d436dd64d4d5d5a404f08"
        
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(API_KEY)&lang=ja&units=metric"
        
        apiManager.request(urlStr,
                           success: { [weak self] (response) in
            guard let self = self else { // HomeViewModelのself
                AKLog(level: .FATAL, message: "[self] FatalError")
                fatalError()
            }
            
            // 天気の様子が返ってくる 例: 曇
            self.weatherDataDiscription = response["weather"][0]["description"].string ?? ""
            
            // 体感気温がdoubleの形で返ってくる　例: 21.52
            if let temp = response["main"]["feels_like"].double {
                let tempStr_simo2keta = String(temp) // 例: "21.52"
                let tempStr_simo1keta = tempStr_simo2keta.prefix(tempStr_simo2keta.count - 1) // 例: "21.5"
                self.weatherDataFeelLike = tempStr_simo1keta + "℃" // 例: "21.5℃"
            }
            
            // 天気を表すアイコンコードが返ってくる 例 "02d"
            if let iconCode = response["weather"][0]["icon"].string {
                let urlStr = "https://openweathermap.org/img/wn/" + iconCode + "@2x.png"
                self.weatherDataIconUrlStr = urlStr
            }
            
            self.state?(.ready) // 通信完了
            
        }, failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
            self?.state?(.error) // エラー表示
        })
    }
    //    メモ
    //        let parameters = [
    //            "lat":"34.0778755",
    //            "lon":"134.5615651",
    //            "appid":"e0578cd3fb0d436dd64d4d5d5a404f08",
    //            "lang":"ja",
    //            "units":"metric"
    //        ]
    //        let URL: String = "https://api.openweathermap.org/data/2.5/weather"
    //        Alamofire.request(URL, method: .post, parameters: parameters)
    //    https://openweathermap.org/img/wn/02d@2x.png
}
