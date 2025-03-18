//
//  FlickrImageSearchUITests.swift
//  FlickrImageSearchUITests
//
//

import XCTest

final class PhotoSearchViewUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testSearchShowsImages() {
        let searchField = app.textFields["SearchField"]
        
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("Nature")
        
        let app = XCUIApplication()
        let gridView = app.otherElements["GridView"]  // Try using otherElements instead of collectionViews
        XCTAssertTrue(gridView.waitForExistence(timeout: 5), "Grid view should display images after typing in search term.")
    }
}
