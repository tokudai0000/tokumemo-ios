//
//  MenuItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

public struct MenuItem: Codable {
    public let title: String
    public let id: MenuItemType
    public let image: String
    public let url: String?
}

public enum MenuItemType: Codable {
    case courseManagement
    case manaba
    case mailService                    // メール
    case libraryRAS
    case coopRAS
    case etc

    case courseManagementHomePC         // 教務事務システム
    case courseManagementHomeMobile
    case manabaHomePC                   // マナバ
    case manabaHomeMobile
    case portal                         // 統合認証ポータル
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
    case careerCenter                   // キャリアセンター
    case coopCalendar                   // 徳島大学生活共同組合
    case cafeteria                      // 徳島大学食堂
    case courseRegistration             // 履修登録
    case systemServiceList              // システムサービス一覧
    case eLearningList                  // Eラーニング一覧
    case universityWeb                  // 大学サイト
    case studySupportSpace              // 学びサポート企画部
    case disasterPrevention             // 上月研究室防災情報
}
