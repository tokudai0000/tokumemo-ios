//
//  univIPTests.swift
//  univIPTests
//
//  Created by Akihiro Matsuyama on 2021/09/24.
//

import XCTest
@testable import univIP

class MainViewModelTests: XCTestCase {
    
    var viewModel = MainViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testIsDomeinCheck() {
        
        // 基本的なテスト
        let url1 = "https://tokushima-u.ac.jp/"
        let test1 = viewModel.isAllowedDomeinCheck(url1)
        XCTAssertEqual(test1, true)
        
        let url2 = "https://microsoftonline.com/"
        let test2 = viewModel.isAllowedDomeinCheck(url2)
        XCTAssertEqual(test2, true)
        
        let url3 = "https://office365.com/"
        let test3 = viewModel.isAllowedDomeinCheck(url3)
        XCTAssertEqual(test3, true)
        
        let url4 = "https://office.com/"
        let test4 = viewModel.isAllowedDomeinCheck(url4)
        XCTAssertEqual(test4, true)
        
        let url5 = "https://youtube.com/"
        let test5 = viewModel.isAllowedDomeinCheck(url5)
        XCTAssertEqual(test5, true)
        
        let url6 = "https://example.com/"
        let test6 = viewModel.isAllowedDomeinCheck(url6)
        XCTAssertEqual(test6, false)
        
        
        // 境界テスト
        let url100 = "https://tokushima-u.ac.jp/aaaa/aaaa/"
        let test100 = viewModel.isAllowedDomeinCheck(url100)
        XCTAssertEqual(test100, true)
        
        let url101 = "https://aaatokushima-u.ac.jp/"
        let test101 = viewModel.isAllowedDomeinCheck(url101)
        XCTAssertEqual(test101, true)
        
        let url102 = "https://takushima-u.ac.jp/"
        let test102 = viewModel.isAllowedDomeinCheck(url102)
        XCTAssertEqual(test102, false)
        
        
        // 稼働テスト
        let url201 = "https://eweb.stud.tokushima-u.ac.jp/Portal/"
        let test201 = viewModel.isAllowedDomeinCheck(url201)
        XCTAssertEqual(test201, true)
        
        let url202 = "https://www.lib.tokushima-u.ac.jp/"
        let test202 = viewModel.isAllowedDomeinCheck(url202)
        XCTAssertEqual(test202, true)
        
        let url203 = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"
        let test203 = viewModel.isAllowedDomeinCheck(url203)
        XCTAssertEqual(test203, true)
        
        let url204 = "https://login.microsoftonline.com/login"
        let test204 = viewModel.isAllowedDomeinCheck(url204)
        XCTAssertEqual(test204, true)
        
        let url205 = "https://login.microsoftonline.com/common/SAS/ProcessAuth"
        let test205 = viewModel.isAllowedDomeinCheck(url205)
        XCTAssertEqual(test205, true)
        
        let url206 = "https://outlook.office365.com/owa/"
        let test206 = viewModel.isAllowedDomeinCheck(url206)
        XCTAssertEqual(test206, true)
        
        let url207 = "https://www.tokudai-syusyoku.com/index.php"
        let test207 = viewModel.isAllowedDomeinCheck(url207)
        XCTAssertEqual(test207, true)
        
        let url208 = "https://manaba.lms.tokushima-u.ac.jp/ct/home"
        let test208 = viewModel.isAllowedDomeinCheck(url208)
        XCTAssertEqual(test208, true)
        
//        let url209 = URL(string: "")!
//        let test209 = viewModel.isDomeinCheck(url209)
//        XCTAssertEqual(test209, true)
//
//        let url210 = URL(string: "")!
//        let test210 = viewModel.isDomeinCheck(url210)
//        XCTAssertEqual(test210, true)
//
//        let url211 = URL(string: "")!
//        let test211 = viewModel.isDomeinCheck(url211)
//        XCTAssertEqual(test211, true)
//
//        let url212 = URL(string: "")!
//        let test212 = viewModel.isDomeinCheck(url212)
//        XCTAssertEqual(test212, true)
//
//        let url213 = URL(string: "")!
//        let test213 = viewModel.isDomeinCheck(url213)
//        XCTAssertEqual(test213, true)
        
    }
    
    func testIsJudgeUrl() {
        do {
            let isRegistrant = true
            let forwardUrl = ""
            let displayUrl = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1"
            let test = viewModel.isJudgeUrl(.login,
                                            isRegistrant: isRegistrant,
                                            forwardUrl: forwardUrl,
                                            displayUrl: displayUrl)
            XCTAssertEqual(test, true)
        }
    }
    
    
}
