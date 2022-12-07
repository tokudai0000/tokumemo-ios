//
//public enum MenuListItemType: String {
//    case courseManagementHomePC         // 教務事務システム
//    case courseManagementHomeMobile
//    case manabaHomePC                   // マナバ
//    case manabaHomeMobile
//    case portal                         // 統合認証ポータル
//    case libraryWebHomePC               // 図書館Webサイト常三島
//    case libraryWebHomeKuraPC           // 図書館Webサイト蔵本
//    case libraryWebHomeMobile
//    case libraryMyPage                  // 図書館MyPage
//    case libraryBookLendingExtension    // 図書館本貸出し期間延長
//    case libraryBookPurchaseRequest     // 図書館本購入リクエスト
//    case libraryCalendar                // 図書館カレンダー
//    case syllabus                       // シラバス
//    case timeTable                      // 時間割
//    case currentTermPerformance         // 今年の成績表
//    case termPerformance                // 成績参照
//    case presenceAbsenceRecord          // 出欠記録
//    case classQuestionnaire             // 授業アンケート
//    case mailService                    // メール
//    case tokudaiCareerCenter            // キャリアセンター
//    case tokudaiCoop                    // 徳島大学生活共同組合
//    case courseRegistration             // 履修登録
//    case systemServiceList              // システムサービス一覧
//    case eLearningList                  // Eラーニング一覧
//    case universityWeb                  // 大学サイト
//}
//
//public struct MenuListItem: Codable {
//    public let title: String
//    public let iconSystemName: String
//    public let url: String?
//    public let isLock: Bool
//    public var isDisplay: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case title
//        case iconSystemName
//        case url
//        case isLock
//        case isDisplay
//    }
//
//    public init(title: String, iconSystemName: String, url: String?, isLock: Bool, isDisplay: Bool) {
//        self.title = title
//        self.iconSystemName = iconSystemName
//        self.url = url
//        self.isLock = isLock
//        self.isDisplay = isDisplay
//    }
//}
//
//extension MenuListItem {
//    public var itemType: MenuListItemType? {
//        return MenuListItemType(rawValue: type)
//    }
//}
//
//public enum MediaListItemType: String {
//    case image
//    case audio
//    case video
//}
//
//public struct MediaListItem: Codable {
//    public let title: String?
//    public let sectionID: Int
//    public let type: String
//    public let showInGallery: Bool
//    public let isLeadImage: Bool
//    public let audioType: String?
//    enum CodingKeys: String, CodingKey {
//        case title
//        case sectionID = "section_id"
//        case showInGallery
//        case isLeadImage = "leadImage"
//        case sources = "srcset"
//        case type
//        case audioType
//    }
//
//    public init(title: String?, sectionID: Int, type: String, showInGallery: Bool, isLeadImage: Bool, audioType: String? = nil) {
//        self.title = title
//        self.sectionID = sectionID
//        self.type = type
//        self.showInGallery = showInGallery
//        self.isLeadImage = isLeadImage
//        self.audioType = audioType
//    }
//}
//
//extension MediaListItem {
//    public var itemType: MediaListItemType? {
//        return MediaListItemType(rawValue: type)
//    }
//}
