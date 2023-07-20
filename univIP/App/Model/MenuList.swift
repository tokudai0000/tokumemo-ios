public enum MenuListItemType: Codable {
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

public struct MenuItemList: Codable {
    public let title: String
    public let id: MenuListItemType
    public let image: String
    public let url: String?
}

let homeMenuLists:[MenuItemList] = [
    MenuItemList(title: "教務システム", id: .courseManagement, image: R.image.menuIcon.courseManagementHome.name, url: Url.courseManagementMobile.string()),
    MenuItemList(title: "manaba", id: .manaba, image: R.image.menuIcon.manaba.name, url: Url.manabaPC.string()),
    MenuItemList(title: "メール", id: .mailService, image: R.image.menuIcon.mailService.name, url: Url.outlookService.string()),
    MenuItemList(title: "図書館 関連", id: .libraryRAS, image: R.image.menuIcon.libraryBookLendingExtension.name, url: nil),
    MenuItemList(title: "生協 関連", id: .coopRAS, image: R.image.menuIcon.coopCalendar.name, url: nil),
    MenuItemList(title: "その他", id: .etc, image: R.image.menuIcon.careerCenter.name, url: nil)
]

let homelibraryRASItemLists = [
    MenuItemList(title: "図書館ホームページ(常三島)", id: .libraryWebHomePC, image: "", url: Url.libraryHomePageMainPC.string()),
    MenuItemList(title: "図書館ホームページ(蔵本)", id: .libraryWebHomeKuraPC, image: "", url: Url.libraryHomePageKuraPC.string()),
    MenuItemList(title: "マイページ", id: .libraryMyPage, image: "", url: Url.libraryMyPage.string()),
    MenuItemList(title: "貸し出し期間延長", id: .libraryBookLendingExtension, image: "", url: Url.libraryBookLendingExtension.string()),
    MenuItemList(title: "購入リクエスト", id: .libraryBookPurchaseRequest, image: "", url: Url.libraryBookPurchaseRequest.string()),
    MenuItemList(title: "[図書]カレンダー", id: .libraryCalendar, image: R.image.menuIcon.libraryCalendar.name, url: nil),
]

let homeCoopRASItemLists = [
    MenuItemList(title: "時間割", id: .timeTable, image: R.image.menuIcon.timetable.name, url: Url.timeTable.string()),
    MenuItemList(title: "今学期の成績", id: .currentTermPerformance, image: "", url: Url.currentTermPerformance.string()),
    MenuItemList(title: "シラバス", id: .syllabus, image: "", url: Url.syllabus.string()),
    MenuItemList(title: "全学期の成績", id: .termPerformance, image: "", url: Url.termPerformance.string()),
    MenuItemList(title: "大学サイト", id: .universityWeb, image: "", url: Url.universityHomePage.string()),
    MenuItemList(title: "出欠記録", id: .presenceAbsenceRecord, image: "", url: Url.presenceAbsenceRecord.string()),
    MenuItemList(title: "授業アンケート", id: .classQuestionnaire, image: "", url: Url.classQuestionnaire.string()),
    MenuItemList(title: "LMS一覧", id: .eLearningList, image: "", url: Url.eLearningList.string()),
]

let homeEtcItemLists = [
    MenuItemList(title: "生協営業時間", id: .coopCalendar, image: "", url: Url.tokudaiCoop.string()),
    MenuItemList(title: "食堂メニュー", id: .cafeteria, image: "", url: Url.tokudaiCoopDinigMenu.string()),
    MenuItemList(title: "キャリア支援室", id: .careerCenter, image: "", url: Url.tokudaiCareerCenter.string()),
    MenuItemList(title: "SSS時間割", id: .studySupportSpace, image: "", url: Url.studySupportSpace.string()),
    MenuItemList(title: "知っておきたい防災", id: .disasterPrevention, image: "", url: Url.disasterPrevention.string()),
]
