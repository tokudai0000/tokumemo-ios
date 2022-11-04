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
    
    // cアカウント、パスワードを登録しているか判定 (読み取り専用)
    private var hasRegisteredPassword: Bool { get { return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty) }}
    
    
    // MARK: - Public
    /// TableCellの内容
    public var collectionLists:[Constant.CollectionCell] = Constant.initCustomCellLists
    
    public var isLoginProcessing = false // ログイン処理中
    public var isLoginComplete = false // ログイン完了
    public var isLoginCompleteImmediately = false // ログイン完了後すぐ
    
    
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
    
    public func getWetherData() {
//        let URL = SF_LOGIN_URL + "/services/oauth2/token"
//        let parameters = [
//            "grant_type":"password",
//            "client_id":SF_CLIENT_ID,
//            "client_secret":SF_CLIENT_SECRET,
//            "username":SF_USERNAME,
//            "password":SF_PASSWORD
//        ]
        let URL: String = "https://api.openweathermap.org/data/2.5/weather?lat=34.0778755&lon=134.5615651&appid=e0578cd3fb0d436dd64d4d5d5a404f08&lang=ja&units=metric"
        Alamofire.request(URL, method: .get)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                print(json.description) // JSONのデータ値
                print(json["cod"].int)
                print(json["name"].string)
                print(json["weather"][0]["description"].string)
//                json.forEach { (_, json) in
////                    let article: [String: String?] = [
////                        "title": json["title"].string,
////                        "userId": json["user"]["id"].string
////                    ]
//                }
            }
//        Alamofire.request(URL)
//            .responseJSON { response in
//                switch response.result {
//                    case .Success(let value):
//                        let json = JSON(value)
//                        print(json)
//
//                        //let access_token = json["access_token"].string
//                        //let instance_url = json["instance_url"].string
//                        //let token_type = json["token_type"].string
//
//                    case .Failure(let error):
//                        print("error")
//                }
//            }

//        AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
//            switch response.result {
//                case .success:
//                    let json: JSON = JSON(response.result ?? kill)
//                    print(json.rawValue)
////                    self.showWeatherAlert(title: json["title"].stringValue, message: json["description"]["text"].stringValue)
//                case .failure(let error):
//                    print(error)
//            }
//        }
        
        
        // AlamofireでAPIリクエストをする
//        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=34.0778755&lon=134.5615651&appid=e0578cd3fb0d436dd64d4d5d5a404f08&lang=ja&units=metric")
//        // レスポンスをJSON形式で受け取る
//            .responseJSON { response in
//                guard let object = response.result.rawValue else {
//                    return
//                }
//                let json = JSON(object)
//                json.forEach { (_, json) in
//                    print(json["weather"])
//                    print(json["description"]) // jsonから"title"がキーのものを取得
//                }
                
//                if let data = response.data {
//                    do {
////                        let articles: TopNest = try JSONDecoder().decode(TopNest.self, from: data)
////
////                        print(articles.weather[0].id!)
////                        print(articles.weather[0].main!)
////                        print(articles.weather[0].description!)
////                        print(articles.weather[0].icon!)
//
//
//                        let json = JSON(object)
//
////                        print(articles.main!.feels_like)
////                        print(articles.main[0].temp_max!)
////                        print(articles.main[0].temp_min!)
////                        print(articles.main[0].feels_like!)
//
//
//
//                    } catch {
//                        print("getDataBase 失敗")
//                        print(error.localizedDescription)
//                    }
//                }else{
//                    print("getDataBase  response.data = nil")
//                }
//            }
    }
}
