//
//  univIPTests.swift
//  univIPTests
//
//  Created by Akihiro Matsuyama on 2021/09/24.
//

import XCTest
@testable import univIP

class MainViewModelTests: XCTestCase {
    
//    var viewModel = HomeViewModel()
//    
//    override func setUp() {
//        super.setUp()
//    }
//    
//    override func tearDown() {
//        super.tearDown()
//    }
//    
//    func testIsAllowedDomainCheck() {
//
//        // 基本的なテスト
//        let url1 = URL(string: "https://tokushima-u.ac.jp/")! // fatalError
//        let test1 = viewModel.isAllowedDomainCheck(url1)
//        XCTAssertEqual(test1, true)
//
//        let url2 = URL(string: "https://microsoftonline.com/")!
//        let test2 = viewModel.isAllowedDomainCheck(url2)
//        XCTAssertEqual(test2, true)
//
//        let url3 = URL(string: "https://office365.com/")!
//        let test3 = viewModel.isAllowedDomainCheck(url3)
//        XCTAssertEqual(test3, true)
//
//        let url4 = URL(string: "https://office.com/")!
//        let test4 = viewModel.isAllowedDomainCheck(url4)
//        XCTAssertEqual(test4, true)
//
//        let url5 = URL(string: "https://youtube.com/")!
//        let test5 = viewModel.isAllowedDomainCheck(url5)
//        XCTAssertEqual(test5, true)
//
//        let url6 = URL(string: "https://example.com/")!
//        let test6 = viewModel.isAllowedDomainCheck(url6)
//        XCTAssertEqual(test6, false)
//
//
//        // 境界テスト
//        let url100 = URL(string: "https://tokushima-u.ac.jp/aaaa/aaaa/")!
//        let test100 = viewModel.isAllowedDomainCheck(url100)
//        XCTAssertEqual(test100, true)
//
//        let url101 = URL(string: "https://aaatokushima-u.ac.jp/")!
//        let test101 = viewModel.isAllowedDomainCheck(url101)
//        XCTAssertEqual(test101, true)
//
//        let url102 = URL(string: "https://takushima-u.ac.jp/")!
//        let test102 = viewModel.isAllowedDomainCheck(url102)
//        XCTAssertEqual(test102, false)
//
//
//        // 稼働テスト
//        let url201 = URL(string: "https://eweb.stud.tokushima-u.ac.jp/Portal/")!
//        let test201 = viewModel.isAllowedDomainCheck(url201)
//        XCTAssertEqual(test201, true)
//
//        let url202 = URL(string: "https://www.lib.tokushima-u.ac.jp/")!
//        let test202 = viewModel.isAllowedDomainCheck(url202)
//        XCTAssertEqual(test202, true)
//
//        let url203 = URL(string: "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/")!
//        let test203 = viewModel.isAllowedDomainCheck(url203)
//        XCTAssertEqual(test203, true)
//
//        let url204 = URL(string: "https://login.microsoftonline.com/login")!
//        let test204 = viewModel.isAllowedDomainCheck(url204)
//        XCTAssertEqual(test204, true)
//
//        let url205 = URL(string: "https://login.microsoftonline.com/common/SAS/ProcessAuth")!
//        let test205 = viewModel.isAllowedDomainCheck(url205)
//        XCTAssertEqual(test205, true)
//
//        let url206 = URL(string: "https://outlook.office365.com/owa/")!
//        let test206 = viewModel.isAllowedDomainCheck(url206)
//        XCTAssertEqual(test206, true)
//
//        let url207 = URL(string: "https://www.tokudai-syusyoku.com/index.php")!
//        let test207 = viewModel.isAllowedDomainCheck(url207)
//        XCTAssertEqual(test207, true)
//
//        let url208 = URL(string: "https://manaba.lms.tokushima-u.ac.jp/ct/home")!
//        let test208 = viewModel.isAllowedDomainCheck(url208)
//        XCTAssertEqual(test208, true)
//    }
    
    

    // dataManagerを内部で使用している為、モックか修正を行う
//    func testAnyJavaScriptExecute() {
//    }
//    func testSearchInitialViewUrl() {
//
//    }
    
    // これは大学図書館ホームページの使用により、頻繁に返り値が変わる。修正
//    func testFetchLibraryCalendarUrl() {
//
//    }
    
}
