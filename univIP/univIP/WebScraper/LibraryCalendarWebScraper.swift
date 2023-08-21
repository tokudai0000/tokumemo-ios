//
//  LibraryCalendarWebScraper.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/15.
//

import Kanna
import RxSwift

protocol LibraryCalendarWebScraperInterface {
    func getLibraryCalendarURL(libraryUrl: URL) -> Single<URLRequest>
}

struct LibraryCalendarWebScraper: LibraryCalendarWebScraperInterface {
    enum LibraryError: Error {
        case networkError(Error)
        case noDataAvailable(statusCode: Int?)
        case parsingError(Error)
        case invalidURL(String)
    }

    private let baseURLString = "https://www.lib.tokushima-u.ac.jp/"

    func getLibraryCalendarURL(libraryUrl: URL) -> RxSwift.Single<URLRequest> {
        return .create { observer in
            let task = URLSession.shared.dataTask(with: libraryUrl) { (data, response , error) in
                if let error = error {
                    return observer(.failure(LibraryError.networkError(error)))
                }

                guard let data = data else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    return observer(.failure(LibraryError.noDataAvailable(statusCode: statusCode)))
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
                    return observer(.failure(LibraryError.parsingError(parseError)))
                }

                guard let url = URL(string: urlStr) else {
                    return observer(.failure(LibraryError.invalidURL(urlStr)))
                }
                observer(.success(URLRequest(url: url)))
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
