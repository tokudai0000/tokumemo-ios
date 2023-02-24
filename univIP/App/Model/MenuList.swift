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
    case sss                            // 学びサポート企画部(Study Support Space)
    
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
let initMenuLists:[MenuListItem] = [
    MenuListItem(title: "教務システム", id: .courseManagementHomeMobile, image: R.image.menuIcon.教務システム.name, url: Url.courseManagementMobile.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "manaba", id: .manabaHomePC, image: R.image.menuIcon.manaba.name, url: Url.manabaPC.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "メール", id: .mailService, image: R.image.menuIcon.メール.name, url: Url.outlookService.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "[図書]本貸出延長", id: .libraryBookLendingExtension, image: R.image.menuIcon.本貸出延長.name, url: Url.libraryBookLendingExtension.string(), isLockIconExists: true, isHiddon: false),
        
    MenuListItem(title: "時間割", id: .timeTable, image: R.image.menuIcon.時間割.name, url: Url.timeTable.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "今学期の成績", id: .currentTermPerformance, image: R.image.menuIcon.今学期の成績.name, url: Url.currentTermPerformance.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "シラバス", id: .syllabus, image: R.image.menuIcon.シラバス.name, url: Url.syllabus.string(), isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "生協カレンダー", id: .tokudaiCoop, image: R.image.menuIcon.生協カレンダー.name, url: Url.tokudaiCoop.string(), isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "今月の食堂メニュー", id: .tokudaiCoop, image: R.image.menuIcon.生協食堂.name, url: Url.tokudaiCoopDinigMenu.string(), isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "[図書]カレンダー", id: .libraryCalendar, image: R.image.menuIcon.図書カレンダー.name, url: nil, isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "[図書]本検索", id: .libraryMyPage, image: R.image.menuIcon.本検索.name, url: Url.libraryMyPage.string(), isLockIconExists: true, isHiddon: false),
        
    MenuListItem(title: "キャリア支援室", id: .tokudaiCareerCenter, image: R.image.menuIcon.キャリア支援室.name, url: Url.tokudaiCareerCenter.string(), isLockIconExists: false, isHiddon: false),
    
    MenuListItem(title: "[図書]本購入", id: .libraryBookPurchaseRequest, image: R.image.menuIcon.本購入.name, url: Url.libraryBookPurchaseRequest.string(), isLockIconExists: true, isHiddon: false),
    
    MenuListItem(title: "SSS時間割", id: .sss, image: "calendar", url: Url.studySupportSpace.string(), isLockIconExists: false, isHiddon: false),
    
    // Hiddon
    
    MenuListItem(title: "統合認証ポータル", id: .portal, image: "graduationcap", url: Url.portal.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "全学期の成績", id: .termPerformance, image: "chart.line.uptrend.xyaxis", url: Url.termPerformance.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "大学サイト", id: .universityWeb, image: "graduationcap", url: Url.universityHomePage.string(), isLockIconExists: false, isHiddon: true),
    
    MenuListItem(title: "教務システム_PC", id: .courseManagementHomePC, image: "graduationcap", url: Url.courseManagementPC.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "マナバ_Mob", id: .manabaHomeMobile, image: "graduationcap", url: Url.manabaMobile.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "図書館サイト", id: .libraryWebHomeMobile, image: "books.vertical", url: Url.libraryHomeMobile.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "出欠記録", id: .presenceAbsenceRecord, image: "graduationcap", url: Url.presenceAbsenceRecord.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "授業アンケート", id: .classQuestionnaire, image: "graduationcap", url: Url.classQuestionnaire.string(), isLockIconExists: true, isHiddon: true),
    
    MenuListItem(title: "LMS一覧", id: .eLearningList, image: "graduationcap", url: Url.eLearningList.string(), isLockIconExists: false, isHiddon: true),
    
    MenuListItem(title: "[図書]HP_常三島", id: .libraryWebHomePC, image: "books.vertical", url: Url.libraryHomePageMainPC.string(), isLockIconExists: false, isHiddon: true),
    
    MenuListItem(title: "[図書]HP_蔵本", id: .libraryWebHomePC, image: "books.vertical", url: Url.libraryHomePageKuraPC.string(), isLockIconExists: false, isHiddon: true),
]
