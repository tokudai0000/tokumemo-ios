//
//  NewsItemsRSS.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Kanna
import RxSwift

protocol NewsItemsRSSInterface {
    func getNewsItems() -> Single<[NewsItemModel]>
}

struct NewsItemsRSS: NewsItemsRSSInterface {
    func getNewsItems() -> RxSwift.Single<[NewsItemModel]> {
        return .create { observer in
            let url = URL(string: "https://www.tokushima-u.ac.jp/recent/rss.xml")! // fatalError

            let task = URLSession.shared.dataTask(with: url) { (data, _ , error) in
                // ここのエラーはクライアントサイドのエラー(ホストに接続できないなど)
                if let error = error {
                    print("クライアントエラー: \(error.localizedDescription)")
                    return observer(.failure(error))
                }
                guard let data = data else {
                    print("no data or no response")
                    return observer(.failure(error!))
                }

                var newsItems:[NewsItemModel] = []
                do {
                    let doc = try Kanna.XML(xml: data, encoding: .utf8)
                    for element in doc.xpath("//item") {
                        let title = element.at_xpath("title")?.text ?? ""
                        let link = element.at_xpath("link")?.text ?? ""
                        let pubDate = element.at_xpath("pubDate")?.text ?? ""
                        // dcDateを取得できない。不明
                        // let dcDate = element.at_xpath("dc:date")?.text ?? ""

                        let item = NewsItemModel(title: title, createdAt: pubDate, targetUrlStr: link)
                        newsItems.append(item)
                    }
                } catch {
                    print("Error parsing XML: \(error.localizedDescription)")
                }
                observer(.success(newsItems))
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
