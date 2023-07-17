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
    case careerCenter                   // キャリアセンター
    case coopCalendar                   // 徳島大学生活共同組合
    case cafeteria                      // 徳島大学食堂
    case courseRegistration             // 履修登録
    case systemServiceList              // システムサービス一覧
    case eLearningList                  // Eラーニング一覧
    case universityWeb                  // 大学サイト
    case studySupportSpace              // 学びサポート企画部
    case disasterPrevention             // 上月研究室防災情報
    
    case favorite
}

public struct MenuItemList: Codable {
    public let title: String
    public let id: MenuListItemType
    public let image: String
    public let url: String?
    public let isLockIconExists: Bool
    public var isHiddon: Bool
}

/// 初期状態
let initMenuLists:[MenuItemList] = [
    MenuItemList(title: "教務システム", id: .courseManagementHomeMobile, image: R.image.menuIcon.courseManagementHome.name, url: Url.courseManagementMobile.string(), isLockIconExists: true, isHiddon: false),
    
    MenuItemList(title: "manaba", id: .manabaHomePC, image: R.image.menuIcon.manaba.name, url: Url.manabaPC.string(), isLockIconExists: true, isHiddon: false),
    
    MenuItemList(title: "メール", id: .mailService, image: R.image.menuIcon.mailService.name, url: Url.outlookService.string(), isLockIconExists: true, isHiddon: false),
    
    MenuItemList(title: "[図書]本貸出延長", id: .libraryBookLendingExtension, image: R.image.menuIcon.libraryBookLendingExtension.name, url: Url.libraryBookLendingExtension.string(), isLockIconExists: true, isHiddon: false),
        
    MenuItemList(title: "時間割", id: .timeTable, image: R.image.menuIcon.timetable.name, url: Url.timeTable.string(), isLockIconExists: true, isHiddon: false),
    
    MenuItemList(title: "今学期の成績", id: .currentTermPerformance, image: R.image.menuIcon.currentTermPerformance.name, url: Url.currentTermPerformance.string(), isLockIconExists: true, isHiddon: false),
    
    MenuItemList(title: "シラバス", id: .syllabus, image: R.image.menuIcon.syllabus.name, url: Url.syllabus.string(), isLockIconExists: false, isHiddon: false),
    
    MenuItemList(title: "生協カレンダー", id: .coopCalendar, image: R.image.menuIcon.coopCalendar.name, url: Url.tokudaiCoop.string(), isLockIconExists: false, isHiddon: false),
    
    MenuItemList(title: "今月の食堂メニュー", id: .cafeteria, image: R.image.menuIcon.cafeteria.name, url: Url.tokudaiCoopDinigMenu.string(), isLockIconExists: false, isHiddon: false),
    
    MenuItemList(title: "[図書]カレンダー", id: .libraryCalendar, image: R.image.menuIcon.libraryCalendar.name, url: nil, isLockIconExists: false, isHiddon: false),
    
    MenuItemList(title: "[図書]本検索", id: .libraryMyPage, image: R.image.menuIcon.libraryMyPage.name, url: Url.libraryMyPage.string(), isLockIconExists: true, isHiddon: false),
        
    MenuItemList(title: "キャリア支援室", id: .careerCenter, image: R.image.menuIcon.careerCenter.name, url: Url.tokudaiCareerCenter.string(), isLockIconExists: false, isHiddon: false),
    
    MenuItemList(title: "[図書]本購入", id: .libraryBookPurchaseRequest, image: R.image.menuIcon.libraryBookPurchaseRequest.name, url: Url.libraryBookPurchaseRequest.string(), isLockIconExists: true, isHiddon: false),
    
    MenuItemList(title: "SSS時間割", id: .studySupportSpace, image: R.image.menuIcon.studySupportSpace.name, url: Url.studySupportSpace.string(), isLockIconExists: false, isHiddon: false),
    
    MenuItemList(title: "知っておきたい防災", id: .disasterPrevention, image: R.image.menuIcon.disasterPrevention.name, url: Url.disasterPrevention.string(), isLockIconExists: false, isHiddon: false),
    
    // Hiddon
    
    MenuItemList(title: "統合認証ポータル", id: .portal, image: R.image.menuIcon.courseManagementHome.name, url: Url.portal.string(), isLockIconExists: true, isHiddon: true),
    
    MenuItemList(title: "全学期の成績", id: .termPerformance, image: R.image.menuIcon.currentTermPerformance.name, url: Url.termPerformance.string(), isLockIconExists: true, isHiddon: true),
    
    MenuItemList(title: "大学サイト", id: .universityWeb, image: R.image.menuIcon.courseManagementHome.name, url: Url.universityHomePage.string(), isLockIconExists: false, isHiddon: true),
    
    MenuItemList(title: "教務システム_PC", id: .courseManagementHomePC, image: R.image.menuIcon.courseManagementHome.name, url: Url.courseManagementPC.string(), isLockIconExists: true, isHiddon: true),
    
    MenuItemList(title: "マナバ_Mob", id: .manabaHomeMobile, image: R.image.menuIcon.manaba.name, url: Url.manabaMobile.string(), isLockIconExists: true, isHiddon: true),
    
    MenuItemList(title: "図書館サイト", id: .libraryWebHomeMobile, image: R.image.menuIcon.libraryBookLendingExtension.name, url: Url.libraryHomeMobile.string(), isLockIconExists: true, isHiddon: true),
    
    MenuItemList(title: "出欠記録", id: .presenceAbsenceRecord, image: R.image.menuIcon.courseManagementHome.name, url: Url.presenceAbsenceRecord.string(), isLockIconExists: true, isHiddon: true),
    
    MenuItemList(title: "授業アンケート", id: .classQuestionnaire, image: R.image.menuIcon.courseManagementHome.name, url: Url.classQuestionnaire.string(), isLockIconExists: true, isHiddon: true),
    
    MenuItemList(title: "LMS一覧", id: .eLearningList, image: R.image.menuIcon.courseManagementHome.name, url: Url.eLearningList.string(), isLockIconExists: false, isHiddon: true),
    
    MenuItemList(title: "[図書]HP_常三島", id: .libraryWebHomePC, image: R.image.menuIcon.libraryBookLendingExtension.name, url: Url.libraryHomePageMainPC.string(), isLockIconExists: false, isHiddon: true),
    
    MenuItemList(title: "[図書]HP_蔵本", id: .libraryWebHomePC, image: R.image.menuIcon.libraryBookLendingExtension.name, url: Url.libraryHomePageKuraPC.string(), isLockIconExists: false, isHiddon: true),
]

let homeMenuLists:[MenuItemList] = [
    MenuItemList(title: "教務システム", id: .courseManagementHomeMobile, image: R.image.menuIcon.courseManagementHome.name, url: Url.courseManagementMobile.string(), isLockIconExists: true, isHiddon: false),

    MenuItemList(title: "manaba", id: .manabaHomePC, image: R.image.menuIcon.manaba.name, url: Url.manabaPC.string(), isLockIconExists: true, isHiddon: false),

    MenuItemList(title: "メール", id: .mailService, image: R.image.menuIcon.mailService.name, url: Url.outlookService.string(), isLockIconExists: true, isHiddon: false),

    MenuItemList(title: "図書館関連", id: .libraryBookLendingExtension, image: R.image.menuIcon.libraryBookLendingExtension.name, url: Url.libraryBookLendingExtension.string(), isLockIconExists: true, isHiddon: false),

    MenuItemList(title: "生協関連", id: .coopCalendar, image: R.image.menuIcon.coopCalendar.name, url: Url.tokudaiCoop.string(), isLockIconExists: false, isHiddon: false),

    MenuItemList(title: "その他", id: .careerCenter, image: R.image.menuIcon.careerCenter.name, url: Url.tokudaiCareerCenter.string(), isLockIconExists: false, isHiddon: false)
]
