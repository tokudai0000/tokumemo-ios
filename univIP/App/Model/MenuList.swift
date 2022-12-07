
public enum MenuListItemType: String {
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
    case mailService                    // メール
    case tokudaiCareerCenter            // キャリアセンター
    case tokudaiCoop                    // 徳島大学生活共同組合
    case courseRegistration             // 履修登録
    case systemServiceList              // システムサービス一覧
    case eLearningList                  // Eラーニング一覧
    case universityWeb                  // 大学サイト
}

public struct MenuListItem: Codable {
    public let title: String
    public let iconSystemName: String
    public let url: String?
    public let isLock: Bool
    public var isDisplay: Bool
    public let type: String

    enum CodingKeys: String, CodingKey {
        case title
        case iconSystemName
        case url
        case isLock
        case isDisplay
        case type
    }

    public init(title: String, iconSystemName: String, url: String?, isLock: Bool, isDisplay: Bool, type: String) {
        self.title = title
        self.iconSystemName = iconSystemName
        self.url = url
        self.isLock = isLock
        self.isDisplay = isDisplay
        self.type = type
    }
    
}

extension MenuListItem {
    public var itemType: MenuListItemType? {
        return MenuListItemType(rawValue: type)
    }
}
