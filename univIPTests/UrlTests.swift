//
//  UrlTests.swift
//  univIPTests
//
//  Created by Akihiro Matsuyama on 2021/12/27.
//

import XCTest
@testable import univIP

class UrlTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    // 網羅するために、手作業で1つづつ行う(他にいい方法見つけたい)
    // Gitの変更を逐一見ていれば、url.stringsが書き換えられるミスは起こらないと思うが、自動化できるのでチェックを行う
    func testUrl() {
        // 以下のURLは
        // URL(string: ) でアンラップできることは確認済み
        // 正常なURLであることは確認済み(接続先の仕様が変わらない限り)
        let universityHomePage = "https://www.tokushima-u.ac.jp/"
        let systemServiceList = "https://www.ait.tokushima-u.ac.jp/service/list_out/"
        let eLearningList = "https://uls01.ulc.tokushima-u.ac.jp/info/index.html"
        
        let courseManagementPC = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx"
        let courseManagementMobile = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx"
        let manabaPC = "https://manaba.lms.tokushima-u.ac.jp/ct/home"
        let manabaMobile = "https://manaba.lms.tokushima-u.ac.jp/s/home_summary"
        
        let timeTable = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx"
        let currentTermPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year="
        let termPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx"
        let presenceAbsenceRecord = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"
        let classQuestionnaire = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx"
        let courseRegistration = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistEdit.aspx"
        
        let libraryHomePageMainPC = "https://www.lib.tokushima-u.ac.jp/"
        let libraryHomePageKuraPC = "https://www.lib.tokushima-u.ac.jp/kura.shtml"
        let libraryHomeMobile = "https://opac.lib.tokushima-u.ac.jp/drupal/"
        let libraryCalendarMain = "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_"
        let libraryCalendarKura = "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_kura_"
        let libraryMyPage = "https://opac.lib.tokushima-u.ac.jp/opac/user/top"
        let libraryBookLendingExtension = "https://opac.lib.tokushima-u.ac.jp/opac/user/holding-borrowings"
        let libraryBookPurchaseRequest = "https://opac.lib.tokushima-u.ac.jp/opac/user/purchase_requests/new"
        
        let outlookLogin = "https://outlook.office365.com/tokushima-u.ac.jp"
        
        let syllabus = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"
        
        let tokudaiCareerCenter = "https://www.tokudai-syusyoku.com/index.php"
        
        let universityTransitionLogin = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
        let universityLogin = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="
        let universityServiceTimeOut = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"
        let enqueteReminder = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"
        let popupToYoutube = "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon"
        
        XCTAssertEqual(universityHomePage, Url.universityHomePage.string())
        XCTAssertEqual(systemServiceList, Url.systemServiceList.string())
        XCTAssertEqual(eLearningList, Url.eLearningList.string())
        XCTAssertEqual(courseManagementPC, Url.courseManagementPC.string())
        XCTAssertEqual(courseManagementMobile, Url.courseManagementMobile.string())
        XCTAssertEqual(manabaPC, Url.manabaPC.string())
        XCTAssertEqual(manabaMobile, Url.manabaMobile.string())
        XCTAssertEqual(timeTable, Url.timeTable.string())
        XCTAssertEqual(currentTermPerformance, Url.currentTermPerformance.string())
        XCTAssertEqual(termPerformance, Url.termPerformance.string())
        XCTAssertEqual(presenceAbsenceRecord, Url.presenceAbsenceRecord.string())
        XCTAssertEqual(classQuestionnaire, Url.classQuestionnaire.string())
        XCTAssertEqual(courseRegistration, Url.courseRegistration.string())
        XCTAssertEqual(libraryHomePageMainPC, Url.libraryHomePageMainPC.string())
        XCTAssertEqual(libraryHomePageKuraPC, Url.libraryHomePageKuraPC.string())
        XCTAssertEqual(libraryHomeMobile, Url.libraryHomeMobile.string())
        XCTAssertEqual(libraryCalendarMain, Url.libraryCalendarMain.string())
        XCTAssertEqual(libraryCalendarKura, Url.libraryCalendarKura.string())
        XCTAssertEqual(libraryMyPage, Url.libraryMyPage.string())
        XCTAssertEqual(libraryBookLendingExtension, Url.libraryBookLendingExtension.string())
        XCTAssertEqual(libraryBookPurchaseRequest, Url.libraryBookPurchaseRequest.string())
        XCTAssertEqual(outlookLogin, Url.outlookService.string())
        XCTAssertEqual(syllabus, Url.syllabus.string())
        XCTAssertEqual(tokudaiCareerCenter, Url.tokudaiCareerCenter.string())
        XCTAssertEqual(universityTransitionLogin, Url.universityTransitionLogin.string())
        XCTAssertEqual(universityLogin, Url.universityLogin.string())
        XCTAssertEqual(universityServiceTimeOut, Url.universityServiceTimeOut.string())
        XCTAssertEqual(enqueteReminder, Url.enqueteReminder.string())
        XCTAssertEqual(popupToYoutube, Url.popupToYoutube.string())
    }
}
