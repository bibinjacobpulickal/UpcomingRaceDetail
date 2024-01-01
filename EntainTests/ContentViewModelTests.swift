//
//  ContentViewModelTests.swift
//  EntainTests
//
//  Created by Bibin Jacob Pulickal on 11/12/23.
//

@testable import Entain
import XCTest

@MainActor final class ContentViewModelTests: XCTestCase {

    private var sut: ContentViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ContentViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testFetchRaces() async {
        // When
        await sut.fetchRaces()
        // Then
        XCTAssertNotNil(sut.races)
    }

    func testSelectCategory_select() {
        // Given
        guard let category = RaceCategory.allCases.randomElement() else { return }
        // When
        sut.selectCategory(category)
        // Then
        XCTAssertTrue(sut.selectedRaceCategories.contains(category))
    }

    func testSelectCategory_deselect() {
        // Given
        guard let category = RaceCategory.allCases.randomElement() else { return }
        sut.selectedRaceCategories = [category]
        // When
        sut.selectCategory(category)
        // Then
        XCTAssertFalse(sut.selectedRaceCategories.contains(category))
    }
}
