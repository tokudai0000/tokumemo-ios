//
//  Common.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/26.
//

import UIKit

class Common {
    
    /// rtfファイルを読み込む
    /// - Parameter url: rtfFileまでのPATH
    /// - Returns: rtfFileの内容
    static func rtfFileLoad(_ filePath: URL) -> NSAttributedString {
        do {
            let terms = try Data(contentsOf: filePath)
            let attributedString = try NSAttributedString(
                data: terms,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
            )
            return attributedString
            
        } catch let error {
            AKLog(level: .FATAL, message: "[Fatalファイルの読み込み失敗]:\(error.localizedDescription)")
            fatalError()
        }
    }
    
}
