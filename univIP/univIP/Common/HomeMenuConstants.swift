//
//  HomeMenuConstants.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/10.
//

import Foundation

struct HomeMenuConstants {
    let menuItems:[MenuItem] = [
        MenuItem(title: R.string.localizable.course_management(),
                 id: .courseManagement,
                 icon: R.image.menuIcon.courseManagementHome.name,
                 targetUrl: Url.courseManagementMobile.urlRequest()),

        MenuItem(title: R.string.localizable.manaba(),
                 id: .manaba,
                 icon: R.image.menuIcon.manaba.name,
                 targetUrl: Url.manabaPC.urlRequest()),

        MenuItem(title: R.string.localizable.mail(),
                 id: .mail,
                 icon: R.image.menuIcon.mailService.name,
                 targetUrl: Url.outlookService.urlRequest()),

        MenuItem(title: R.string.localizable.academic_related(),
                 id: .academicRelated,
                 icon: R.image.menuIcon.coopCalendar.name,
                 targetUrl: nil),

        MenuItem(title: R.string.localizable.library_related(),
                 id: .libraryRelated,
                 icon: R.image.menuIcon.libraryBookLendingExtension.name,
                 targetUrl: nil),

        MenuItem(title: R.string.localizable.etc(),
                 id: .etc,
                 icon: R.image.menuIcon.careerCenter.name,
                 targetUrl: nil)
    ]

    let academicRelatedItems = [
        MenuDetailItem(title: R.string.localizable.time_table(),
                       id: .timeTable,
                       targetUrl: Url.timeTable.urlRequest()),

        MenuDetailItem(title: R.string.localizable.current_term_performance(),
                       id: .currentTermPerformance,
                       targetUrl: Url.currentTermPerformance.urlRequest()),

        MenuDetailItem(title: R.string.localizable.syllabus(),
                       id: .syllabus,
                       targetUrl: Url.syllabus.urlRequest()),

        MenuDetailItem(title: R.string.localizable.term_performance(),
                       id: .termPerformance,
                       targetUrl: Url.termPerformance.urlRequest()),

        MenuDetailItem(title: R.string.localizable.university_web(),
                       id: .universityWeb,
                       targetUrl: Url.universityHomePage.urlRequest()),

        MenuDetailItem(title: R.string.localizable.presence_absence_record(),
                       id: .presenceAbsenceRecord,
                       targetUrl: Url.presenceAbsenceRecord.urlRequest()),

        MenuDetailItem(title: R.string.localizable.class_questionnaire(),
                       id: .classQuestionnaire,
                       targetUrl: Url.classQuestionnaire.urlRequest()),

        MenuDetailItem(title: R.string.localizable.eLearning_list(),
                       id: .eLearningList,
                       targetUrl: Url.eLearningList.urlRequest()),

        //        MenuDetailItem(title: R.string.localizable.portal(),
        //                 id: .portal,
        //                 targetUrl: Url.eLearningList.urlRequest()),
    ]

    let libraryRelatedItems = [
        MenuDetailItem(title: R.string.localizable.library_web_home_pc(),
                       id: .libraryWebHomePC,
                       targetUrl: Url.libraryHomePageMainPC.urlRequest()),

        MenuDetailItem(title: R.string.localizable.library_web_home_kura_pc(),
                       id: .libraryWebHomeKuraPC,
                       targetUrl: Url.libraryHomePageKuraPC.urlRequest()),

        //        MenuDetailItem(title: R.string.localizable.library_web_home_mobile(),
        //                 id: .libraryWebHomeMobile,
        //                 targetUrl: Url.libraryHomePageKuraPC.urlRequest()),

        MenuDetailItem(title: R.string.localizable.library_my_page(),
                       id: .libraryMyPage,
                       targetUrl: Url.libraryMyPage.urlRequest()),

        MenuDetailItem(title: R.string.localizable.library_book_lending_extension(),
                       id: .libraryBookLendingExtension,
                       targetUrl: Url.libraryBookLendingExtension.urlRequest()),

        MenuDetailItem(title: R.string.localizable.library_book_purchase_request(),
                       id: .libraryBookPurchaseRequest,
                       targetUrl: Url.libraryBookPurchaseRequest.urlRequest()),

        MenuDetailItem(title: R.string.localizable.library_calendar(),
                       id: .libraryCalendar,
                       targetUrl: nil),
    ]

    let etcItems = [
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
}
