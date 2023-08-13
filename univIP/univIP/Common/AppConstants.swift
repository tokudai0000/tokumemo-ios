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

    enum Color {
        static let navigation: UIColor = .init(red255: 0, green255: 78, blue255: 152)
        static let sansanBlue: UIColor = .init(red255: 0, green255: 78, blue255: 152)
        static let sansanProductBlue: UIColor = .init(red255: 5, green255: 121, blue255: 230)
        static let sansanBlack: UIColor = .init(red255: 34, green255: 34, blue255: 34)
        static let sansanGray: UIColor = .init(red255: 117, green255: 117, blue255: 117)
        static let backGroundGray: UIColor = .init(red255: 242, green255: 242, blue255: 242)
    }
}
