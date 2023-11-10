//
//  CreditsViewModelTests.swift
//  univIPTests
//
//  Created by Akihiro Matsuyama on 2023/11/10.
//

import RxSwift
import XCTest
@testable import univIP

final class CreditsViewModelTests: XCTestCase {
    private var viewModel: CreditsViewModelInterface!
    private var mockRouter: MockCreditsRouter!
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        mockRouter = MockCreditsRouter()
        viewModel = CreditsViewModel(
            input: .init(),
            state: .init(),
            dependency: .init(router: mockRouter)
        )
    }

    func testViewDidLoad() {
        viewModel.input.viewDidLoad.accept(())
        viewModel.output.creditItems
            .subscribe(onNext: { items in
                XCTAssertNotEqual(items, [])
            })
            .disposed(by: disposeBag)
    }

    func testDidTapBackButton() {
        viewModel.input.didTapBackButton.accept(())
        XCTAssertEqual(mockRouter.lastNavigationType, .back)
    }
}

final class MockCreditsRouter: CreditsRouterInterface {
    var lastNavigationType: CreditsNavigationDestination?

    func navigate(_ destination: CreditsNavigationDestination) {
        lastNavigationType = destination
    }
}
