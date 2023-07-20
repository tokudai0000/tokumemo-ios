//
//  ConstStruct.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

struct ConstStruct {
    /// 現在の利用規約バージョン
    static let latestTermsVersion = "3.0"
}

let homeMenuLists:[MenuItem] = [
    MenuItem(title: "教務システム", id: .courseManagement, image: R.image.menuIcon.courseManagementHome.name, url: Url.courseManagementMobile.string()),
    MenuItem(title: "manaba", id: .manaba, image: R.image.menuIcon.manaba.name, url: Url.manabaPC.string()),
    MenuItem(title: "メール", id: .mailService, image: R.image.menuIcon.mailService.name, url: Url.outlookService.string()),
    MenuItem(title: "図書館 関連", id: .libraryRAS, image: R.image.menuIcon.libraryBookLendingExtension.name, url: nil),
    MenuItem(title: "生協 関連", id: .coopRAS, image: R.image.menuIcon.coopCalendar.name, url: nil),
    MenuItem(title: "その他", id: .etc, image: R.image.menuIcon.careerCenter.name, url: nil)
]

let homelibraryRASItemLists = [
    MenuItem(title: "図書館ホームページ(常三島)", id: .libraryWebHomePC, image: "", url: Url.libraryHomePageMainPC.string()),
    MenuItem(title: "図書館ホームページ(蔵本)", id: .libraryWebHomeKuraPC, image: "", url: Url.libraryHomePageKuraPC.string()),
    MenuItem(title: "マイページ", id: .libraryMyPage, image: "", url: Url.libraryMyPage.string()),
    MenuItem(title: "貸し出し期間延長", id: .libraryBookLendingExtension, image: "", url: Url.libraryBookLendingExtension.string()),
    MenuItem(title: "購入リクエスト", id: .libraryBookPurchaseRequest, image: "", url: Url.libraryBookPurchaseRequest.string()),
    MenuItem(title: "[図書]カレンダー", id: .libraryCalendar, image: R.image.menuIcon.libraryCalendar.name, url: nil),
]

let homeCoopRASItemLists = [
    MenuItem(title: "時間割", id: .timeTable, image: R.image.menuIcon.timetable.name, url: Url.timeTable.string()),
    MenuItem(title: "今学期の成績", id: .currentTermPerformance, image: "", url: Url.currentTermPerformance.string()),
    MenuItem(title: "シラバス", id: .syllabus, image: "", url: Url.syllabus.string()),
    MenuItem(title: "全学期の成績", id: .termPerformance, image: "", url: Url.termPerformance.string()),
    MenuItem(title: "大学サイト", id: .universityWeb, image: "", url: Url.universityHomePage.string()),
    MenuItem(title: "出欠記録", id: .presenceAbsenceRecord, image: "", url: Url.presenceAbsenceRecord.string()),
    MenuItem(title: "授業アンケート", id: .classQuestionnaire, image: "", url: Url.classQuestionnaire.string()),
    MenuItem(title: "LMS一覧", id: .eLearningList, image: "", url: Url.eLearningList.string()),
]

let homeEtcItemLists = [
    MenuItem(title: "生協営業時間", id: .coopCalendar, image: "", url: Url.tokudaiCoop.string()),
    MenuItem(title: "食堂メニュー", id: .cafeteria, image: "", url: Url.tokudaiCoopDinigMenu.string()),
    MenuItem(title: "キャリア支援室", id: .careerCenter, image: "", url: Url.tokudaiCareerCenter.string()),
    MenuItem(title: "SSS時間割", id: .studySupportSpace, image: "", url: Url.studySupportSpace.string()),
    MenuItem(title: "知っておきたい防災", id: .disasterPrevention, image: "", url: Url.disasterPrevention.string()),
]

let homeTableItemLists = [
    SettingsItem(title: "PR画像(広告)の申請", id: .termsOfService, url: Url.prApplication.string()),
    SettingsItem(title: "バグや新規機能の相談", id: .termsOfService, url: Url.contactUs.string()),
    SettingsItem(title: "利用規約", id: .termsOfService, url: Url.termsOfService.string()),
    SettingsItem(title: "プライバシーポリシー", id: .privacyPolicy, url: Url.privacyPolicy.string())
]
