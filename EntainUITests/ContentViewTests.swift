//
//  ContentViewTests.swift
//  EntainUITests
//
//  Created by Bibin Jacob Pulickal on 11/12/23.
//

import XCTest

final class ContentViewTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    func testContentViewLoad() {
        // Given
        let navigationBar = XCUIApplication().navigationBars["Races"]
        // When
        app.launch()
        // Then
        XCTAssertTrue(navigationBar.exists)
    }
}
