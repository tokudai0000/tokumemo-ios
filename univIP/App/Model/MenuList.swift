public enum MenuListItemType: Codable {
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
    
    case favorite
}

public struct MenuListItem: Codable {
    public let title: String
    public let id: MenuListItemType
    public let image: String
    public let url: String?
    public let isLockIconExists: Bool
    public var isHiddon: Bool
}

/// 初期状態
let initMenuLists = [
    MenuListItem(title: "教務システム", id: .courseManagementHomeMobile, image: "graduationcap", url: Url.courseManagementMobile.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "manaba", id: .manabaHomePC, image: "graduationcap", url: Url.manabaPC.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "メール", id: .mailService, image: "envelope", url: Url.outlookService.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "[図書]カレンダー", id: .libraryCalendar, image: "calendar", url: nil, isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "[図書]本検索", id: .libraryMyPage, image: "books.vertical", url: Url.libraryMyPage.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "[図書]本貸出延長", id: .libraryBookLendingExtension, image: "books.vertical", url: Url.libraryBookLendingExtension.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "生協カレンダー", id: .tokudaiCoop, image: "calendar", url: Url.tokudaiCoop.string(), isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "時間割", id: .timeTable, image: "calendar", url: Url.timeTable.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "統合認証ポータル", id: .portal, image: "graduationcap", url: Url.portal.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "今学期の成績", id: .currentTermPerformance, image: "chart.line.uptrend.xyaxis", url: Url.currentTermPerformance.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "全学期の成績", id: .termPerformance, image: "chart.line.uptrend.xyaxis", url: Url.termPerformance.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "シラバス", id: .syllabus, image: "graduationcap", url: Url.syllabus.string(), isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "キャリア支援室", id: .tokudaiCareerCenter, image: "questionmark.folder", url: Url.tokudaiCareerCenter.string(), isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "大学サイト", id: .universityWeb, image: "graduationcap", url: Url.universityHomePage.string(), isLockIconExists: false, isHiddon: true),
    
    MenuListItem(title: "教務システム_PC", id: .courseManagementHomePC, image: "graduationcap", url: Url.courseManagementPC.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "マナバ_Mob", id: .manabaHomeMobile, image: "graduationcap", url: Url.manabaMobile.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "図書館サイト", id: .libraryWebHomeMobile, image: "books.vertical", url: Url.libraryHomeMobile.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "[図書]本購入", id: .libraryBookPurchaseRequest, image: "books.vertical", url: Url.libraryBookPurchaseRequest.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "出欠記録", id: .presenceAbsenceRecord, image: "graduationcap", url: Url.presenceAbsenceRecord.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "授業アンケート", id: .classQuestionnaire, image: "graduationcap", url: Url.classQuestionnaire.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "LMS一覧", id: .eLearningList, image: "graduationcap", url: Url.eLearningList.string(), isLockIconExists: false, isHiddon: true),
    
    MenuListItem(title: "[図書]HP_常三島", id: .libraryWebHomePC, image: "books.vertical", url: Url.libraryHomePageMainPC.string(), isLockIconExists: false, isHiddon: true),
    
    MenuListItem(title: "[図書]HP_蔵本", id: .libraryWebHomePC, image: "books.vertical", url: Url.libraryHomePageKuraPC.string(), isLockIconExists: false, isHiddon: true),
]
