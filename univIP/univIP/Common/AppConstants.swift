//
//  AppConstants.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

enum AppConstants {
    /// 現在の利用規約バージョン
    /// Note これはいずれなくす
    static let latestTermsVersion: String = "3.0"

    /// rtfファイルを読み込む
    /// - Parameter url: rtfFileまでのPATH
    /// - Returns: rtfFileの内容
    /// 使用例
    /// let filePath = R.file.aboutThisAppRtf()!
    /// textView.attributedText = Common.loadRtfFileContents(filePath)
    static func loadRtfFileContents(_ filePath: URL) -> NSAttributedString {
        do {
            let terms = try Data(contentsOf: filePath)
            let attributedString = try NSAttributedString(
                data: terms,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
            )
            return attributedString

        } catch let error {
            AKLog(level: .FATAL, message: "[rtfファイルのDataパース失敗]:\(error.localizedDescription)")
            fatalError()
        }
    }
}
