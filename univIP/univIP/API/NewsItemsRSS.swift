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
    func getNewsItems() -> Single<[NewsItem]>
//    func getNewsItems()
}

struct NewsItemsRSS: NewsItemsRSSInterface {
    func getNewsItems() -> RxSwift.Single<[NewsItem]> {
        return .create { observer in
            let url = URL(string: "https://www.tokushima-u.ac.jp/recent/rss.xml")! // fatalError

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                // エラーハンドリング
                if let error = error {
                    print("Error fetching XML: \(error.localizedDescription)")
                    return observer(.failure(error))
                }

                guard let data = data else {
                    print("No data found")
                    return observer(.failure(error!))
                }

                var newsItems:[NewsItem] = []
                do {
                    // XMLデータの解析
                    let doc = try Kanna.XML(xml: data, encoding: .utf8)

                    // XPathやCSSセレクタを使用してデータを取得
                    for element in doc.xpath("//item") {
                        let title = element.at_xpath("title")?.text
                        let link = element.at_xpath("link")?.text
                        let pubDate = element.at_xpath("pubDate")?.text
                        let dcDate = element.at_xpath("dc:date")?.text


                        let item = NewsItem(title: title!, createdAt: Date(), targetUrlStr: link!)
                        newsItems.append(item)
//                        print(element.text ?? "") // 要素のテキストを取得
                    }
                } catch {
                    print("Error parsing XML: \(error.localizedDescription)")
                }

                observer(.success(newsItems))
            }

            // タスクを開始
            task.resume()

            return Disposables.create { task.cancel() }
        }





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
