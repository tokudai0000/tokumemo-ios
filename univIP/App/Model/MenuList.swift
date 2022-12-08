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
}

public struct MenuListItem: Codable {
    public let title: String
    public let iconSources: String
    public let url: String?
    public let showLockIcon: Bool
    public var showItem: Bool
    public let type: MenuListItemType

//    enum CodingKeys: String, CodingKey {
//        case title
//        case iconSources
//        case url
//        case showLockIcon
//        case showItem
//        case type
//    }

    public init(title: String, iconSources: String, url: String?, showLockIcon: Bool, showItem: Bool, type: MenuListItemType) {
        self.title = title
        self.iconSources = iconSources
        self.url = url
        self.showLockIcon = showLockIcon
        self.showItem = showItem
        self.type = type
    }
    
}


public struct MenuList: Codable {
    public let items: [MenuListItem]

    public init(items: [MenuListItem]) {
        self.items = items
    }
    
    // This failable initializer is used for a single-image MediaList, given via a URL.
//    public init?(from url: URL?) {
//        guard let imageURL = url,
//              let imageName = WMFParseUnescapedNormalizedImageNameFromSourceURL(imageURL) else {
//                  return nil
//              }
//        let filename = "File:" + imageName
//        let urlString = imageURL.absoluteString
//
//        let mediaListItem = MenuListItem(title: filename,
//                                         iconSources: "",
//                                         url: "",
//                                         showLockIcon: true,
//                                         showItem: true,
//                                         type: "")
//        self = MenuList(items: [mediaListItem])
//    }
}
/// CollectionCell初期状態
let initCollectionCellLists = [
    MenuListItem(title: "教務システム",
                 iconSources: "graduationcap",
                 url: Url.courseManagementMobile.string(),
                 showLockIcon: true,
                 showItem: true,
                 type: .courseManagementHomeMobile)
    
//    CollectionCell(title: "manaba",
//                   id: .manabaHomePC,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.manabaPC.string()
//                  ),
//
//    CollectionCell(title: "メール",
//                   id: .mailService,
//                   iconSystemName: "envelope",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.outlookService.string()
//                  ),
//
//    CollectionCell(title: "[図書]カレンダー",
//                   id: .libraryCalendar,
//                   iconSystemName: "calendar",
//                   lockIconSystemName: nil,
//                   url: nil
//                  ),
//
//    CollectionCell(title: "[図書]本検索",
//                   id: .libraryMyPage,
//                   iconSystemName: "books.vertical",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.libraryMyPage.string()
//                  ),
//
//    CollectionCell(title: "[図書]本貸出延長",
//                   id: .libraryBookLendingExtension,
//                   iconSystemName: "books.vertical",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.libraryBookLendingExtension.string()
//                  ),
//
//    CollectionCell(title: "生協カレンダー",
//                   id: .tokudaiCoop,
//                   iconSystemName: "questionmark.folder",
//                   lockIconSystemName: nil,
//                   url: Url.tokudaiCoop.string()
//                  ),
//
//    CollectionCell(title: "時間割",
//                   id: .timeTable,
//                   iconSystemName: "calendar",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.timeTable.string()
//                  ),
//
//    CollectionCell(title: "統合認証ポータル",
//                   id: .portal,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.portal.string()
//                  ),
//
//    CollectionCell(title: "今学期の成績",
//                   id: .currentTermPerformance,
//                   iconSystemName: "chart.line.uptrend.xyaxis",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.currentTermPerformance.string()
//                  ),
//
//    CollectionCell(title: "全学期の成績",
//                   id: .termPerformance,
//                   iconSystemName: "chart.line.uptrend.xyaxis",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.termPerformance.string()
//                  ),
//
//    CollectionCell(title: "シラバス",
//                   id: .syllabus,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: nil,
//                   url: Url.syllabus.string()
//                  ),
//
//    CollectionCell(title: "キャリア支援室",
//                   id: .tokudaiCareerCenter,
//                   iconSystemName: "questionmark.folder",
//                   lockIconSystemName: nil,
//                   url: Url.tokudaiCareerCenter.string()
//                  ),
//
//    CollectionCell(title: "大学サイト",
//                   id: .universityWeb,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: nil,
//                   url: Url.universityHomePage.string()
//                  ),
//
//    CollectionCell(title: "教務システム_PC",
//                   id: .courseManagementHomePC,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.courseManagementPC.string()
//                  ),
//
//    CollectionCell(title: "マナバ_Mob",
//                   id: .manabaHomeMobile,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.manabaMobile.string()
//                  ),
//
//    CollectionCell(title: "図書館サイト",
//                   id: .libraryWebHomeMobile,
//                   iconSystemName: "books.vertical",
//                   lockIconSystemName: nil,
//                   url: Url.libraryHomeMobile.string()
//                  ),
//
//    CollectionCell(title: "[図書]本購入",
//                   id: .libraryBookPurchaseRequest,
//                   iconSystemName: "books.vertical",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.libraryBookPurchaseRequest.string()
//                  ),
//
//    CollectionCell(title: "出欠記録",
//                   id: .presenceAbsenceRecord,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.presenceAbsenceRecord.string()
//                  ),
//
//    CollectionCell(title: "授業アンケート",
//                   id: .classQuestionnaire,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: "lock.fill",
//                   url: Url.classQuestionnaire.string()
//                  ),
//
//    CollectionCell(title: "LMS一覧",
//                   id: .eLearningList,
//                   iconSystemName: "graduationcap",
//                   lockIconSystemName: nil,
//                   url: Url.eLearningList.string()
//                  ),
//
//    CollectionCell(title: "[図書]HP_常三島",
//                   id: .libraryWebHomePC,
//                   iconSystemName: "books.vertical",
//                   lockIconSystemName: nil,
//                   url: Url.libraryHomePageMainPC.string()
//                  ),
//
//    CollectionCell(title: "[図書]HP_蔵本",
//                   id: .libraryWebHomePC,
//                   iconSystemName: "books.vertical",
//                   lockIconSystemName: nil,
//                   url: Url.libraryHomePageKuraPC.string()
//                  ),
    ]

