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
    
//    func testIsCourceManagementUrlForPC() {
//        let courceManagementHomePC = Url.courceManagementHomeMobile.string()
//        let courceManagementHomeSP = Url.courceManagementHomePC.string()
//        let manabaPC = Url.manabaHomeMobile.string()
//        let manabaSP = Url.manabaHomePC.string()
//        
//        // 基本的なテスト
//        let test1 = viewModel.isCourceManagementUrlForPC(displayUrl: courceManagementHomePC)
//        XCTAssertEqual(test1, .courceManagementPC)
//        
//        let test2 = viewModel.isCourceManagementUrlForPC(displayUrl: courceManagementHomeSP)
//        XCTAssertEqual(test2, .courceManagementMobile)
//        
//        let test3 = viewModel.isCourceManagementUrlForPC(displayUrl: manabaPC)
//        XCTAssertEqual(test3, .manabaPC)
//        
//        let test4 = viewModel.isCourceManagementUrlForPC(displayUrl: manabaSP)
//        XCTAssertEqual(test4, .manabaMobile)
//        
//        // エラー処理　fatalError()
////        let test5 = viewModel.isCourceManagementUrlForPC(displayUrl: "")
////        XCTAssertThrowsError(test5)
//    }
    

    func testTabBarDetection() {
        let courceManagementHomePC = WebViewModel().url(.courceManagementHomePC)
        let courceManagementHomeSP = WebViewModel().url(.courceManagementHomeSP)
        let manabaPC = WebViewModel().url(.manabaPC)
        let manabaSP = WebViewModel().url(.manabaSP)
        let systemServiceList = WebViewModel().url(.systemServiceList)
        let eLearningList = WebViewModel().url(.eLearningList)
        
        // 基本的なテスト
        let test1 = viewModel.tabBarDetection(tabBarRowValue: 1, isRegist: true, courceType: "PC", manabaType: "")
        XCTAssertEqual(test1, courceManagementHomePC)
        
        let test2 = viewModel.tabBarDetection(tabBarRowValue: 1, isRegist: true, courceType: "Mobile", manabaType: "")
        XCTAssertEqual(test2, courceManagementHomeSP)
        
        let test3 = viewModel.tabBarDetection(tabBarRowValue: 1, isRegist: false, courceType: "", manabaType: "")
        XCTAssertEqual(test3, systemServiceList)
        
        
        let test10 = viewModel.tabBarDetection(tabBarRowValue: 2, isRegist: true, courceType: "", manabaType: "PC")
        XCTAssertEqual(test10, manabaPC)
        
        let test20 = viewModel.tabBarDetection(tabBarRowValue: 2, isRegist: true, courceType: "", manabaType: "Mobile")
        XCTAssertEqual(test20, manabaSP)
        
        let test30 = viewModel.tabBarDetection(tabBarRowValue: 2, isRegist: false, courceType: "", manabaType: "")
        XCTAssertEqual(test30, eLearningList)
    }
    

    func testviewPosisionType() {
        
        // 基本的なテスト
        let test1 = viewModel.viewVerticallyMoveButtonImage( .moveUp, posisionY: -10.0)
        XCTAssertNil(test1, "[now] up, [next] up -> nil")
        
        
        let test2 = viewModel.viewVerticallyMoveButtonImage( .moveDown, posisionY: -10.0)!
        XCTAssertEqual(test2, "chevron.up", "[now] up, [next] down -> chevron.up")
        
        
        let test3 = viewModel.viewVerticallyMoveButtonImage( .moveUp, posisionY: 60.0)!
        XCTAssertEqual(test3, "chevron.down", "[now] down, [next] up -> chevron.down")
        
        
        let test4 = viewModel.viewVerticallyMoveButtonImage( .moveDown, posisionY: 60.0)
        XCTAssertNil(test4, "[now] down, [next] down -> nil")
        
        // 境界値テスト
        let test10 = viewModel.viewVerticallyMoveButtonImage( .moveUp, posisionY: 0.0)
        XCTAssertNil(test10, "[now] up, [next] up -> nil")
        
        let test20 = viewModel.viewVerticallyMoveButtonImage( .moveDown, posisionY: 0.0)!
        XCTAssertEqual(test20, "chevron.up", "[now] up, [next] down -> chevron.up")
        
    }

}
