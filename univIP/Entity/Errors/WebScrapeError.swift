//
//  WebScrapeError.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/21.
//

public enum WebScrapeError: Error {
    case networkError(Error)
    case noDataAvailable(statusCode: Int?)
    case parsingError(Error)
    case invalidURL(String)
}
