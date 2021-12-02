//
//  univIPTests.swift
//  univIPTests
//
//  Created by Akihiro Matsuyama on 2021/09/24.
//

import XCTest
@testable import univIP

class MainViewModelTests: XCTestCase {
    
    var viewModel: MainViewModel!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }


    func testviewPosisionType() {
        XCTAssertEqual(viewModel.viewPosisionType(.up, posisionY: 0), (.down, .viewUp))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
