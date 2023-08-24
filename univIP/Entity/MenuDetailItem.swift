//
//  MenuDetailItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/10.
//

import Foundation

public struct MenuDetailItem {
    public enum type {
        case timeTable                      // 時間割
        case currentTermPerformance         // 今年の成績表
        case syllabus                       // シラバス
        case termPerformance                // 成績参照
        case presenceAbsenceRecord          // 出欠記録
        case classQuestionnaire             // 授業アンケート
        case systemServiceList              // システムサービス一覧
        case eLearningList                  // Eラーニング一覧
        case courseRegistration             // 履修登録
        case universityWeb                  // 大学サイト
        case portal                         // 統合認証ポータル

        case libraryWebHomePC               // 図書館Webサイト常三島
        case libraryWebHomeKuraPC           // 図書館Webサイト蔵本
        case libraryWebHomeMobile
        case libraryMyPage                  // 図書館MyPage
        case libraryBookLendingExtension    // 図書館本貸出し期間延長
        case libraryBookPurchaseRequest     // 図書館本購入リクエスト
        case libraryCalendarMain            // 図書館カレンダー
        case libraryCalendarKura

        case coopCalendar                   // 徳島大学生活共同組合
        case cafeteria                      // 徳島大学食堂
        case careerCenter                   // キャリアセンター
        case studySupportSpace              // 学びサポート企画部
        case disasterPrevention             // 上月研究室防災情報
        case superEnglish                   // スーパー英語
    }

    public let title: String
    public let id: type
    public let targetUrl: URLRequest?

    public init(title: String, id: type, targetUrl: URLRequest?) {
        self.title = title
        self.id = id
        self.targetUrl = targetUrl
    }
}
