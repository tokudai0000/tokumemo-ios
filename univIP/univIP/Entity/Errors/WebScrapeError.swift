//
//  WebScrapeError.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/21.
//

enum WebScrapeError: Error {
    case networkError(Error)
    case noDataAvailable(statusCode: Int?)
    case parsingError(Error)
    case invalidURL(String)
}
