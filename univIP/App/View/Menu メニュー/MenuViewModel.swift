//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/28.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Kanna

final class MenuViewModel {
    
    // TableCellの内容
    public var menuLists:[Constant.Menu] = []
    
    private let dataManager = DataManager.singleton
    
    /// 大学図書館の種類
    enum LibraryType {
        case main // 常三島本館
        case kura // 蔵本分館
    }
    /// 図書館の開館カレンダーPDFまでのURLRequestを作成する
    ///
    /// PDFへのURLは状況により変化する為、図書館ホームページからスクレイピングを行う
    /// 例1：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021.pdf
    /// 例2：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021_syuusei1.pdf
    /// ==HTML==[常三島(本館Main) , 蔵本(分館Kura)でも同様]
    /// <body class="index">
    ///   <ul>
    ///       <li class="pos_r">
    ///         <a href="pub/pdf/calender/calender_main_2021.pdf title="開館カレンダー">
    ///   ========
    ///   aタグのhref属性を抽出、"pub/pdf/calender/"と一致していれば、例1のURLを作成する。
    /// - Parameter type: 常三島(本館Main) , 蔵本(分館Kura)のどちらの開館カレンダーを欲しいのかLibraryTypeから選択
    /// - Returns: 図書館の開館カレンダーPDFまでのURLRequest
    public func makeLibraryCalendarUrl(type: LibraryType) -> URLRequest? {
        var urlString = ""
        switch type {
            case .main:
                urlString = Url.libraryCalendarMain.string()
            case .kura:
                urlString = Url.libraryCalendarKura.string()
        }
        let url = URL(string: urlString)! // fatalError
        do {
            // URL先WebページのHTMLデータを取得
            let data = NSData(contentsOf: url as URL)! as Data
            let doc = try HTML(html: data, encoding: String.Encoding.utf8)
            // aタグ(HTMLでのリンクの出発点と到達点を指定するタグ)を抽出
            for node in doc.xpath("//a") {
                // href属性(HTMLでの目当ての資源の所在を指し示す属性)に設定されている文字列を出力
                guard let str = node["href"] else {
                    AKLog(level: .ERROR, message: "[href属性出力エラー]: href属性に設定されている文字列を出力する際のエラー")
                    return nil
                }
                // 開館カレンダーは図書ホームページのカレンダーボタンにPDFへのURLが埋め込まれている
                if str.contains("pub/pdf/calender/") {
                    // PDFまでのURLを作成する(本館のURLに付け加える)
                    let pdfUrlString = Url.libraryHomePageMainPC.string() + str
                    
                    if let url = URL(string: pdfUrlString) {
                        return URLRequest(url: url)
                    } else {
                        AKLog(level: .ERROR, message: "[URLフォーマットエラー]: 図書館開館カレンダーURL取得エラー \n pdfUrlString:\(pdfUrlString)")
                        return nil
                    }
                }
            }
            AKLog(level: .ERROR, message: "[URL抽出エラー]: 図書館開館カレンダーURLの抽出エラー \n urlString:\(url.absoluteString)")
        } catch {
            AKLog(level: .ERROR, message: "[Data取得エラー]: 図書館開館カレンダーHTMLデータパースエラー\n urlString:\(url.absoluteString)")
        }
        return nil
    }
    
    /// 今年度の成績表のURLを作成する
    ///
    /// - Note:
    ///   2020年4月〜2021年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2020
    ///   2021年4月〜2022年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2021
    ///   なので、2022年の1月から3月まではURLがyear=2021とする必要あり
    /// - Returns: 今年度の成績表のURL
    public func createCurrentTermPerformanceUrl() -> URLRequest? {
        
        var year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        
        // 1月から3月までは前年の成績
        if month <= 3 {
            year -= 1
        }
        
        let urlString = Url.currentTermPerformance.string() + String(year)
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
            
        } else {
            AKLog(level: .ERROR, message: "[URLフォーマットエラー]: 今年度の成績表URL生成エラー urlString:\(urlString)")
            return nil
        }
    }
    
    /// メニューリストにある特定のセルのインデックスを探す
    /// - Parameter id: インデックスを特定したいセルのID
    /// - Returns: インデックス番号
    public func searchIndexCell(id: Constant.MenuLists) -> Int? {
        for i in 0..<menuLists.count {
            if menuLists[i].id == id {
                return i
            }
        }
        return nil
    }
    
}
