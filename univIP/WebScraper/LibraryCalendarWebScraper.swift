//
//  LibraryCalendarWebScraper.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/15.
//

import Kanna
import RxSwift
import Entity

public protocol LibraryCalendarWebScraperInterface {
    func getLibraryCalendarURL(libraryUrl: URL) -> Single<URLRequest>
}

public struct LibraryCalendarWebScraper: LibraryCalendarWebScraperInterface {
    public init() {}

    private let baseURLString = "https://www.lib.tokushima-u.ac.jp/"

    public func getLibraryCalendarURL(libraryUrl: URL) -> RxSwift.Single<URLRequest> {
        return .create { observer in
            let task = URLSession.shared.dataTask(with: libraryUrl) { (data, response , error) in
                if let error = error {
                    return observer(.failure(WebScrapeError.networkError(error)))
                }

                guard let data = data else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    return observer(.failure(WebScrapeError.noDataAvailable(statusCode: statusCode)))
                }

                var urlStr = self.baseURLString
                do {
                    let doc = try HTML(html: data, encoding: String.Encoding.utf8)
                    for node in doc.xpath("//a") {
                        if let str = node["href"], str.contains("pub/pdf/calender/") {
                            urlStr = urlStr + str
                        }
                    }
                } catch let parseError {
                    return observer(.failure(WebScrapeError.parsingError(parseError)))
                }

                guard let url = URL(string: urlStr) else {
                    return observer(.failure(WebScrapeError.invalidURL(urlStr)))
                }
                observer(.success(URLRequest(url: url)))
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
