//
//  LibraryCalendarWebScraper.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/15.
//

import Kanna
import RxSwift

protocol LibraryCalendarWebScraperInterface {
    func getLibraryCalendarURL(libraryUrl: URLRequest) -> Single<URLRequest>
}

/**
 図書館の開館カレンダーPDFまでのURLRequestを作成する
 PDFへのURLは状況により変化する為、図書館ホームページからスクレイピングを行う
 例1：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021.pdf
 例2：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021_syuusei1.pdf
 ==HTML==[常三島(本館Main) , 蔵本(分館Kura)でも同様]
 <body class="index">
 <ul>
 <li class="pos_r">
 <a href="pub/pdf/calender/calender_main_2021.pdf title="開館カレンダー">
 ========
 aタグのhref属性を抽出、"pub/pdf/calender/"と一致していれば、例1のURLを作成する。
 - Parameter type: 常三島(本館Main) , 蔵本(分館Kura)のどちらの開館カレンダーを欲しいのかLibraryTypeから選択
 - Returns: 図書館の開館カレンダーPDFまでのString
 */
struct LibraryCalendarWebScraper: LibraryCalendarWebScraperInterface {
    func getLibraryCalendarURL(libraryUrl: URLRequest) -> RxSwift.Single<URLRequest> {
        return .create { observer in
            guard let url = libraryUrl.url else{ return }

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

                var urlStr = ""
//
//                do {
//                    // URL先WebページのHTMLデータを取得
//                    // let data = try NSData(contentsOf: url) as Data
//                    let doc = try HTML(html: data, encoding: String.Encoding.utf8)
//                    // タグ(HTMLでのリンクの出発点と到達点を指定するタグ)を抽出
//                    for node in doc.xpath("//a") {
//                        // 属性(HTMLでの目当ての資源の所在を指し示す属性)に設定されている文字列を出力
//                        if let str = node["href"] {
//                            // 開館カレンダーは図書ホームページのカレンダーボタンにPDFへのURLが埋め込まれている
//                            if str.contains("pub/pdf/calender/") {
//                                // PDFまでのURLを作成する(本館のURLに付け加える)
//                                urlStr = Url.libraryHomePageMainPC.string() + str
//                            }
//                        }
//                    }
//                } catch {
//                    AKLog(level: .ERROR, message: "[Data取得エラー]: 図書館開館カレンダーHTMLデータパースエラー\n urlString:\(url.absoluteString)")
//                    return observer(.failure(error))
//                }
                observer(.success(libraryUrl: urlStr))
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
