//
//  NewsItemsRSS.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/09.
//

import Kanna
import RxSwift
import Entity

protocol NewsItemsRSSInterface {
    func getNewsItems() -> Single<[NewsItemModel]>
}

struct NewsItemsRSS: NewsItemsRSSInterface {

    private let baseURLString = "https://www.tokushima-u.ac.jp/recent/rss.xml"

    func getNewsItems() -> RxSwift.Single<[NewsItemModel]> {
        return .create { observer in
            guard let url = URL(string: baseURLString) else {
                observer(.failure(WebScrapeError.invalidURL(baseURLString)))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    return observer(.failure(WebScrapeError.networkError(error)))
                }

                guard let data = data else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    return observer(.failure(WebScrapeError.noDataAvailable(statusCode: statusCode)))
                }

                var newsItems:[NewsItemModel] = []
                do {
                    let doc = try Kanna.XML(xml: data, encoding: .utf8)
                    for element in doc.xpath("//item") {
                        let title = element.at_xpath("title")?.text ?? ""
                        let link = element.at_xpath("link")?.text ?? ""
                        let pubDate = element.at_xpath("pubDate")?.text ?? ""
                        // dcDateを取得できない。使わないデータなので放置
                        // let dcDate = element.at_xpath("dc:date")?.text ?? ""

                        let item = NewsItemModel(title: title, targetUrlStr: link, createdAt: pubDate)
                        newsItems.append(item)
                    }
                } catch let parseError {
                    return observer(.failure(WebScrapeError.parsingError(parseError)))
                }
                observer(.success(newsItems))
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
