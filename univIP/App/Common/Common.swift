//
//  Common.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/26.
//

import UIKit

class Common {
    /// タイプメソッド(class func)にすることでインスタンスを生成する手間を省く
    
    /// rtfファイルを読み込む
    class func rtfFileLoad(url: URL) -> NSMutableAttributedString {
        // エラー処理は呼び出し側で実施するべき
        do {
            let terms = try Data(contentsOf: url)
            let attributedString = try NSAttributedString(data: terms,
                                                          options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf],
                                                          documentAttributes: nil)
            
            
            let mutableString = NSMutableAttributedString(string: attributedString.string,
                                                          attributes:[
                                                            .font:UIFont(name:"Futura-Medium", size:15)!,
                                                            .foregroundColor:UIColor.label,
                                                          ])
            
            return mutableString
            
        } catch let error {
            AKLog(level: .FATAL, message: "[Fatalファイルの読み込み失敗]:\(error.localizedDescription)")
            fatalError()
        }
    }
    
}
