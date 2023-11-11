//
//  UrlTests.swift
//  univIPTests
//
//  Created by Akihiro Matsuyama on 2021/12/27.
//

import XCTest
@testable import univIP

class UrlTests: XCTestCase {

    func testUrlValidity() {
        for urlCase in Url.allCases {
            let urlString = urlCase.string()
            let urlRequest = urlCase.urlRequest()

            // URL文字列が空でないことをチェック
            XCTAssertNotEqual(urlString, "", "URL文字列は空ではいけません。")

            // URLリクエストがnilでないことをチェック
            XCTAssertNotNil(urlRequest, "URLRequestはnilであってはいけません。")

            // URLの構文チェック
            XCTAssertNotNil(URL(string: urlString), "無効なURL構文: \(urlString)")
        }
    }

    // 非同期テスト
    func testUrlAccessibility() {
        // JavaScript判定に使用しているのみのURLはテストでは除外する
        let exclusionUrl = [Url.emptyRequest, Url.outlookLoginForm]

        let expectation = XCTestExpectation(description: "URLアクセステスト")

        for urlCase in Url.allCases {
            if exclusionUrl.contains(urlCase) { continue }

            let urlString = urlCase.string()
            guard let url = URL(string: urlString) else {
                XCTFail("無効なURL: \(urlString)")
                continue
            }

            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    XCTAssertEqual(httpResponse.statusCode, 200, "URLアクセス失敗: \(urlString)")
                } else {
                    XCTFail("URLリクエスト失敗: \(urlString)")
                }
                expectation.fulfill()
            }
            task.resume()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
