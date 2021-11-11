//
//  FileModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation

final class FileModel {
        
    func rtfFileLoad(url: URL? ) -> NSAttributedString {
        if let url = url {
            do {
                let terms = try Data(contentsOf: url)
                let attributedString = try NSAttributedString(data: terms,
                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                                             documentAttributes: nil)
                return attributedString
                        
            } catch let error {
                print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
            }
        }
        return NSAttributedString()
    }
    
}
