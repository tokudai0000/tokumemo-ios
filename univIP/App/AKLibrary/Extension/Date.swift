//
//  Date.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/02/10.
//

import Foundation

// 参考 https://www.fuwamaki.com/article/157

extension Date {
    // ◯秒前
    func secondBefore(_ second: Int) -> Date {
        let day = Calendar.current.date(byAdding: .second, value: -second, to: self)
        return day!
    }
}
