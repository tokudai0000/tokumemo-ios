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

class HomeViewModel: BaseViewModel, BaseViewModelProtocol {

    //MARK: - MODEL モデル
    // 広告のURL
    struct Advertisement {
        public var image:String?
        public var intro:String?
        public var url:String?
    }
    public var adItems:[Advertisement] = []
    public var displayAdImagesNumber: Int? // 表示している広告がadItemsに入っている配列番号
    
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

        case adBusy
        case adReady
        case adError
    }
    public var state: ((State) -> Void)?
    
    // MARK: - Public func

    /// 最新の利用規約同意者か判定し、同意画面の表示を行うべきか判定
    public func shouldShowTermsAgreementView() -> Bool {
        return dataManager.agreementVersion != ConstStruct.latestTermsVersion
    }
    
    // 学生番号、パスワードを登録しているか判定
    public func hasRegisteredPassword() -> Bool {
        return !(dataManager.cAccount.isEmpty || dataManager.password.isEmpty)
    }
    
    // GitHub上に0-2までのpngがある場合、ここでは
    // 0.png -> 1.png -> 2.png -> 0.png とローテーションする
    // その判定を3.pngをデータ化した際エラーが出ると、3.pngが存在しないと判定し、0.pngを読み込ませる
    public func getAdItems() {
        adItems.removeAll()
        
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue") // 直列
        
        var adItemsCount: Int?
        var adNumberUrl = URL(string: "https://raw.githubusercontent.com/tokudai0000/hostingImage/main/tokumemoPlus/adNumber.txt")!
        
        #if STUB // テスト環境
        adNumberUrl = URL(string: "https://raw.githubusercontent.com/tokudai0000/hostingImage/main/test/adNumber.txt")!
        #endif
        
        do {
            // URL先WebページのHTMLデータを取得
            let data = try NSData(contentsOf: adNumberUrl) as Data
            let doc = try HTML(html: data, encoding: String.Encoding.utf8)
            if let tx = doc.body?.text {
                adItemsCount = Int(tx)
            }
        } catch {
            AKLog(level: .ERROR, message: "txtファイル存在せず")
            return
        }
    
        guard let count = adItemsCount else {
            AKLog(level: .DEBUG, message: "GitHubに指定された広告数がゼロ")
            return
        }
        
        
        for i in 0 ..< count {
            
            var adImageUrlStrForGitHub: String?
            var adClientWebsiteUrlStr: String?
            var adClientIntroductionText: String?
            
            // 1つ目の並列処理
            dispatchGroup.enter()
            dispatchQueue.async {
                var imgUrlStr = "https://tokudai0000.github.io/hostingImage/tokumemoPlus/Image/" + String(i) + ".png"
                
                #if STUB // テスト環境
                imgUrlStr = "https://tokudai0000.github.io/hostingImage/test/Image/" + String(i) + ".png"
                #endif
                
                let imgUrl = URL(string: imgUrlStr)
                
                do {
                    // GitHubから画像データの取得を判定
                    let _ = try Data(contentsOf: imgUrl!)
                    adImageUrlStrForGitHub = imgUrlStr
                } catch {
                    AKLog(level: .ERROR, message: "URLから画像を取得できませんでした。")
                }
                dispatchGroup.leave() // 1つ目の終了
            }
            
            // 2つ目の並列処理
            dispatchGroup.enter()
            dispatchQueue.async {
                var textUrlStr = "https://raw.githubusercontent.com/tokudai0000/hostingImage/main/tokumemoPlus/Introduction/" + String(i) + ".txt"
                #if STUB // テスト環境
                textUrlStr = "https://raw.githubusercontent.com/tokudai0000/hostingImage/main/test/Introduction/" + String(i) + ".txt"
                #endif
                if let textUrl = URL(string: textUrlStr) {
                    adClientIntroductionText = self.getTxtDataFromGitHub(url: textUrl)
                }
                dispatchGroup.leave() // 2つ目終了
            }
            
            // 3つ目の並列処理
            dispatchGroup.enter()
            dispatchQueue.async {
                var textUrlStr = "https://raw.githubusercontent.com/tokudai0000/hostingImage/main/tokumemoPlus/Url/" + String(i) + ".txt"
                #if STUB // テスト環境
                textUrlStr = "https://raw.githubusercontent.com/tokudai0000/hostingImage/main/test/Url/" + String(i) + ".txt"
                #endif
                if let textUrl = URL(string: textUrlStr) {
                    adClientWebsiteUrlStr = self.getTxtDataFromGitHub(url: textUrl)
                }
                dispatchGroup.leave() // 2つ目終了
            }
            
            // 上の二つの処理が終わった時（両方の dispatchGroup.leave() が呼ばれた時）実行される
            dispatchGroup.notify(queue: .main) {
                if let img = adImageUrlStrForGitHub,
                   let txt = adClientIntroductionText,
                   let ul = adClientWebsiteUrlStr {
                    self.adItems.append(Advertisement(image: img, intro: txt, url: ul))
                    
                }else{
                    self.state?(.adReady)
                }
            }
        }
    }
    
    public func selectAdImageNumber() -> Int? {
        // 広告数が0か1の場合はローテーションする必要がない
        if adItems.count == 0 {
            return nil
        } else if adItems.count == 1 {
            return 0
        }
        
        while true {
            let randomNum = Int.random(in: 0..<adItems.count)
            // 前回の画像表示番号と同じであれば、再度繰り返す
            if randomNum != displayAdImagesNumber {
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
    public func shouldWebViewRelogin() -> Bool {
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
            var displayLists:[MenuListItem] = []
            var menuSumple = initMenuLists
            for oldItem in dataManager.menuLists {
                for i in 0..<menuSumple.count {
                    if oldItem.id == menuSumple[i].id {
                        if !oldItem.isHiddon {
                            displayLists.append(oldItem)
                        }
                        menuSumple.remove(at: i)
                        break
                    }
                }
            }
            for item in menuSumple {
                displayLists.append(item)
            }
            dataManager.menuLists = displayLists
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
