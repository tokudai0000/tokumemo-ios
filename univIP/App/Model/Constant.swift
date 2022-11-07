//
//  model.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import Foundation
import Rswift
import UIKit

final class Constant {
    
    /// 現在の利用規約バージョン
    static let latestTermsVersion = "1.0.2"
    
    /// メニューの種類
    enum MenuLists {
        case courseManagementHomePC         // 教務事務システム
        case courseManagementHomeMobile
        case manabaHomePC                   // マナバ
        case manabaHomeMobile
        case libraryWebHomePC               // 図書館Webサイト常三島
        case libraryWebHomeKuraPC           // 図書館Webサイト蔵本
        case libraryWebHomeMobile
        case libraryMyPage                  // 図書館MyPage
        case libraryBookLendingExtension    // 図書館本貸出し期間延長
        case libraryBookPurchaseRequest     // 図書館本購入リクエスト
        case libraryCalendar                // 図書館カレンダー
        case syllabus                       // シラバス
        case timeTable                      // 時間割
        case currentTermPerformance         // 今年の成績表
        case termPerformance                // 成績参照
        case presenceAbsenceRecord          // 出欠記録
        case classQuestionnaire             // 授業アンケート
        case mailService                    // メール
        case tokudaiCareerCenter            // キャリアセンター
        case tokudaiCoop                    // 徳島大学生活共同組合
        case courseRegistration             // 履修登録
        case systemServiceList              // システムサービス一覧
        case eLearningList                  // Eラーニング一覧
        case universityWeb                  // 大学サイト
        case setting                        // 設定
        
        
        case password                       // パスワード
        case customize                      // 並び替え
        
        case aboutThisApp                   // このアプリについて
        case contactUs                      // お問い合わせ
        case officialSNS                    // 公式SNS
        case homePage                       // ホームページ
        
        case termsOfService                     // 利用規約
        case privacyPolicy                  // プライバシーポリシー
        case license                        // ライセンス
        case acknowledgments                // 謝辞
        
        
        case favorite                       // お気に入り登録
        case initPageSetting                // 初期画面設定
        case buckToMenu                     // 戻る
    }
    
    struct CollectionCell {
        let title: String             // 表示名
        let id: MenuLists             // 識別しやすいようにIDを作成　タイポミスの軽減
        let iconUnLock: UIImage?       // ImageData
        let iconLock: UIImage?  // ImageData
        let url: String?              // 関連したURLを保持 URLRequestはDecodableになる為、不可
        var isDisplay: Bool = true    // 初期値は全てtrue
    }
    
    /// サービスCell初期状態
    ///
    /// - Note:
    ///   更新確認、初回利用者はここを確認される
    static let initCustomCellLists = [
        CollectionCell(title: "教務事務システム",
                       id: .courseManagementHomeMobile,
                       iconUnLock: UIImage(systemName: "graduationcap"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.courseManagementMobile.string()
                      ),
        
        CollectionCell(title: "マナバ",
                       id: .manabaHomePC,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.manabaPC.string()
                      ),
        
        CollectionCell(title: "図書貸し出し延長",
                       id: .libraryBookLendingExtension,
                       iconUnLock: UIImage(systemName: "books.vertical"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.libraryBookLendingExtension.string()
                      ),
        
        CollectionCell(title: "開館カレンダー",
                       id: .libraryCalendar,
                       iconUnLock: UIImage(systemName: "calendar"),
                       iconLock: nil,
                       url: nil
                      ),
        
        CollectionCell(title: "生協営業状況",
                       id: .tokudaiCoop,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: nil,
                       url: Url.tokudaiCoop.string()
                      ),
        
        CollectionCell(title: "シラバス",
                       id: .syllabus,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: nil,
                       url: Url.syllabus.string()
                      ),
        
        CollectionCell(title: "今期の成績",
                       id: .currentTermPerformance,
                       iconUnLock: UIImage(systemName: "chart.line.uptrend.xyaxis"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.currentTermPerformance.string()
                      ),
        
        CollectionCell(title: "メール",
                       id: .mailService,
                       iconUnLock: UIImage(systemName: "envelope.badge"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.outlookService.string()
                      ),
        
        CollectionCell(title: "キャリア支援室",
                       id: .tokudaiCareerCenter,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: nil,
                       url: Url.tokudaiCareerCenter.string()
                      ),
        
        CollectionCell(title: "教務事務システム[PC]",
                       id: .courseManagementHomePC,
                       iconUnLock: UIImage(systemName: "graduationcap"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.courseManagementPC.string()
                      ),
        
        CollectionCell(title: "マナバ[Mobile]",
                       id: .manabaHomeMobile,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.manabaMobile.string()
                      ),
        
        CollectionCell(title: "図書Web[常三島]",
                       id: .libraryWebHomePC,
                       iconUnLock: UIImage(systemName: "books.vertical"),
                       iconLock: nil,
                       url: Url.libraryHomePageMainPC.string()
                      ),
        
        CollectionCell(title: "図書Web[蔵本]",
                       id: .libraryWebHomePC,
                       iconUnLock: UIImage(systemName: "books.vertical"),
                       iconLock: nil,
                       url: Url.libraryHomePageKuraPC.string()
                      ),
        
        CollectionCell(title: "図書Web[Mobile]",
                       id: .libraryWebHomeMobile,
                       iconUnLock: UIImage(systemName: "books.vertical"),
                       iconLock: nil,
                       url: Url.libraryHomeMobile.string()
                      ),
        
        CollectionCell(title: "図書MyPage",
                       id: .libraryMyPage,
                       iconUnLock: UIImage(systemName: "books.vertical"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.libraryMyPage.string()
                      ),
        
        CollectionCell(title: "図書本購入リクエスト",
                       id: .libraryBookPurchaseRequest,
                       iconUnLock: UIImage(systemName: "books.vertical"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.libraryBookPurchaseRequest.string()
                      ),
        
        CollectionCell(title: "時間割",
                       id: .timeTable,
                       iconUnLock: UIImage(systemName: "calendar"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.timeTable.string()
                      ),
        
        CollectionCell(title: "成績参照",
                       id: .termPerformance,
                       iconUnLock: UIImage(systemName: "chart.line.uptrend.xyaxis"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.termPerformance.string()
                      ),
        
        CollectionCell(title: "出欠記録",
                       id: .presenceAbsenceRecord,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.presenceAbsenceRecord.string()
                      ),
        
        CollectionCell(title: "授業アンケート",
                       id: .classQuestionnaire,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: UIImage(systemName: "lock.fill"),
                       url: Url.classQuestionnaire.string()
                      ),
        
        CollectionCell(title: "システムサービス一覧",
                       id: .systemServiceList,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: nil,
                       url: Url.systemServiceList.string()
                      ),
        
        CollectionCell(title: "Eラーニング(LMS)一覧",
                       id: .eLearningList,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: nil,
                       url: Url.eLearningList.string()
                      ),
        
        CollectionCell(title: "大学サイト",
                       id: .universityWeb,
                       iconUnLock: UIImage(systemName: "questionmark.folder"),
                       iconLock: nil,
                       url: Url.universityHomePage.string()
                      )
    ]
    
    
    struct MenuCell {
        let title: String             // 表示名
        let id: MenuLists             // 識別しやすいようにIDを作成　タイポミスの軽減
    }
    /// サービスCell初期状態
    ///
    /// - Note:
    ///   更新確認、初回利用者はここを確認される
    static let initMenuCellLists = [
        [
            MenuCell(title: "パスワード設定",
                     id: .password),
//            MenuCell(title: "カスタマイズ",
//                     id: .customize)
        ],[
            MenuCell(title: "このアプリについて",
                     id: .aboutThisApp),
            MenuCell(title: "お問い合わせ",
                     id: .contactUs),
            MenuCell(title: "公式SNS",
                     id: .officialSNS),
            MenuCell(title: "ホームページ",
                     id: .homePage),
        ],[
            MenuCell(title: "利用規約",
                     id: .termsOfService),
            MenuCell(title: "プライバシーポリシー",
                     id: .privacyPolicy),
            MenuCell(title: "ライセンス",
                     id: .license),
            MenuCell(title: "謝辞",
                     id: .acknowledgments)
        ]]

}
