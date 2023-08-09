//
//  NewsItemsRSS.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import RxSwift
import SwiftyJSON
import Kanna

/// AdItemはPRアイテムとUnivアイテムで使用する
/// PRアイテムは大学生が大学生に向けて告知したい内容。比較的掲載が簡単
/// Univアイテムは教員や学生が、大学生に向けて有用な情報だと判断した内容。
protocol NewsItemsRSSInterface {
//    func getAdItems() -> Single<[NewsItem]>
    func getNewsItems()
}

struct NewsItemsRSS: NewsItemsRSSInterface {
//    func getAdItems() -> RxSwift.Single<[NewsItem]> {
    func getNewsItems() {
        let url = URL(string: "https://www.tokushima-u.ac.jp/recent/rss.xml")! // fatalError

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // エラーハンドリング
            if let error = error {
                print("Error fetching XML: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data found")
                return
            }

            do {
                // XMLデータの解析
                let doc = try Kanna.XML(xml: data, encoding: .utf8)

                // XPathやCSSセレクタを使用してデータを取得
                for element in doc.xpath("//item") {
                    print(element.text ?? "") // 要素のテキストを取得
                }
            } catch {
                print("Error parsing XML: \(error.localizedDescription)")
            }
        }

        // タスクを開始
        task.resume()







//        let request = AdItemsGetRequest()
//        return .create { observer in
//            let session = Session.send(request) { result in
//                switch result {
//                case let .success(response):
//                    observer(.success(response))
//                case let .failure(error):
//                    observer(.failure(error))
//                }
//            }
//            return Disposables.create {
//                session?.cancel()


    }
}

//struct NewsItemsRSSRequest: Request {
//    struct ResponseBody: Decodable {
//        let newsItems: [NewsItem]
//
//        init(object: Any) throws {
//            guard let dictionary = object as? [String: Any],
//                  let prItemsArray = dictionary["prItems"] as? [[String: Any]],
//                  let univItemsArray = dictionary["univItems"] as? [[String: Any]] else {
//                throw ResponseError.unexpectedObject(object)
//            }
//
//            newsItems = try prItemsArray.map { try NewsItem(dictionary: $0) }
//        }
//    }
//
//    typealias Response = ResponseBody
//}
