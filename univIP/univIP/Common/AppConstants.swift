//
//  AppConstants.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/09/17.
//

import Entity

struct AppConstants {
    enum version {
        // 利用規約のバージョン
        static let termsOfServiceVersion = "3.1.0"
    }

    public let menuItems: [MenuItem]
    public let academicRelatedItems: [MenuDetailItem]
    public let libraryRelatedItems: [MenuDetailItem]
    public let etcItems: [MenuDetailItem]
    public let homeMiniSettingsItems: [HomeMiniSettingsItem]
    public let settingsItems: [[SettingsItem]]

    public init() {
        menuItems = [
            MenuItem(title: R.string.localizable.course_management(),
                     id: .courseManagement,
                     icon: R.image.courseManagementHome(),
                     targetUrl: Url.courseManagementMobile.urlRequest()),

            MenuItem(title: R.string.localizable.manaba(),
                     id: .manaba,
                     icon: R.image.manaba(),
                     targetUrl: Url.manabaPC.urlRequest()),

            MenuItem(title: R.string.localizable.mail(),
                     id: .mail,
                     icon: R.image.mailService(),
                     targetUrl: Url.outlookService.urlRequest()),

            MenuItem(title: R.string.localizable.academic_related(),
                     id: .academicRelated,
                     icon: R.image.coopCalendar(),
                     targetUrl: nil),

            MenuItem(title: R.string.localizable.library_related(),
                     id: .libraryRelated,
                     icon: R.image.libraryBookLendingExtension(),
                     targetUrl: nil),

            MenuItem(title: R.string.localizable.etc(),
                     id: .etc,
                     icon: R.image.careerCenter(),
                     targetUrl: nil)
        ]
        academicRelatedItems = [
            MenuDetailItem(title: R.string.localizable.time_table(),
                           id: .timeTable,
                           targetUrl: Url.timeTable.urlRequest()),

            MenuDetailItem(title: R.string.localizable.current_term_performance(),
                           id: .currentTermPerformance,
                           targetUrl: Url.currentTermPerformance.urlRequest()),

            MenuDetailItem(title: R.string.localizable.syllabus(),
                           id: .syllabus,
                           targetUrl: Url.syllabus.urlRequest()),

            MenuDetailItem(title: R.string.localizable.presence_absence_record(),
                           id: .presenceAbsenceRecord,
                           targetUrl: Url.presenceAbsenceRecord.urlRequest()),

            MenuDetailItem(title: R.string.localizable.term_performance(),
                           id: .termPerformance,
                           targetUrl: Url.termPerformance.urlRequest()),
        ]
        libraryRelatedItems = [
            MenuDetailItem(title: R.string.localizable.library_calendar_main(),
                           id: .libraryCalendarMain,
                           targetUrl: Url.libraryHomePageMainPC.urlRequest()),

            MenuDetailItem(title: R.string.localizable.library_calendar_kura(),
                           id: .libraryCalendarKura,
                           targetUrl: Url.libraryHomePageKuraPC.urlRequest()),

            MenuDetailItem(title: R.string.localizable.library_book_lending_extension(),
                           id: .libraryBookLendingExtension,
                           targetUrl: Url.libraryBookLendingExtension.urlRequest()),

            MenuDetailItem(title: R.string.localizable.library_book_purchase_request(),
                           id: .libraryBookPurchaseRequest,
                           targetUrl: Url.libraryBookPurchaseRequest.urlRequest()),

            MenuDetailItem(title: R.string.localizable.library_my_page(),
                           id: .libraryMyPage,
                           targetUrl: Url.libraryMyPage.urlRequest()),
        ]
        etcItems = [
            MenuDetailItem(title: R.string.localizable.coop_calendar(),
                           id: .coopCalendar,
                           targetUrl: Url.tokudaiCoop.urlRequest()),

            MenuDetailItem(title: R.string.localizable.cafeteria(),
                           id: .cafeteria,
                           targetUrl: Url.tokudaiCoopDinigMenu.urlRequest()),

            MenuDetailItem(title: R.string.localizable.career_center(),
                           id: .careerCenter,
                           targetUrl: Url.tokudaiCareerCenter.urlRequest()),

            MenuDetailItem(title: R.string.localizable.study_support_space(),
                           id: .studySupportSpace,
                           targetUrl: Url.studySupportSpace.urlRequest()),

            MenuDetailItem(title: R.string.localizable.disaster_prevention(),
                           id: .disasterPrevention,
                           targetUrl: Url.disasterPrevention.urlRequest()),
        ]
        homeMiniSettingsItems = [
            HomeMiniSettingsItem(title: R.string.localizable.pr_application(),
                                 id: .prApplication,
                                 targetUrl: Url.prApplication.urlRequest()),

            HomeMiniSettingsItem(title: R.string.localizable.contact_us(),
                                 id: .contactUs,
                                 targetUrl: Url.contactUs.urlRequest()),

            HomeMiniSettingsItem(title: R.string.localizable.home_page(),
                                 id: .homePage,
                                 targetUrl: Url.homePage.urlRequest()),

            HomeMiniSettingsItem(title: R.string.localizable.terms_of_service(),
                                 id: .termsOfService,
                                 targetUrl: Url.termsOfService.urlRequest()),

            HomeMiniSettingsItem(title: R.string.localizable.privacy_policy(),
                                 id: .privacyPolicy,
                                 targetUrl: Url.privacyPolicy.urlRequest()),

            HomeMiniSettingsItem(title: R.string.localizable.review(),
                                 id: .review,
                                 targetUrl: Url.review.urlRequest())
        ]
        settingsItems = [
            [
                SettingsItem(title: R.string.localizable.password(),
                             id: .password,
                             targetUrl: nil)
            ],

            [
                SettingsItem(title: R.string.localizable.about_app(),
                             id: .aboutThisApp,
                             targetUrl: Url.appIntroduction.urlRequest()),

                SettingsItem(title: R.string.localizable.home_page(),
                             id: .homePage,
                             targetUrl: Url.homePage.urlRequest()),

                SettingsItem(title: R.string.localizable.contact_us(),
                             id: .contactUs,
                             targetUrl: Url.contactUs.urlRequest()),

                SettingsItem(title: R.string.localizable.offical_SNS(),
                             id: .officialSNS,
                             targetUrl: Url.officialSNS.urlRequest()),

                SettingsItem(title: R.string.localizable.terms_of_service(),
                             id: .termsOfService,
                             targetUrl: Url.termsOfService.urlRequest()),

                SettingsItem(title: R.string.localizable.privacy_policy(),
                             id: .privacyPolicy,
                             targetUrl: Url.privacyPolicy.urlRequest()),

                SettingsItem(title: R.string.localizable.source_code(),
                             id: .sourceCode,
                             targetUrl: Url.sourceCode.urlRequest()),

                SettingsItem(title: R.string.localizable.review(),
                             id: .review,
                             targetUrl: Url.review.urlRequest()),

                SettingsItem(title: R.string.localizable.acknowledgements(),
                             id: .acknowledgements,
                             targetUrl: nil),
            ]
        ]
    }
}
