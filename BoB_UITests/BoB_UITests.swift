//
//  BoB_UITests.swift
//  BoB_UITests
//
//  Created by Ramar Parham on 1/16/24.
//

import XCTest
@testable import BoB

final class BoB_UITests: XCTestCase {

    func testNavigationTitle() throws {
        let app = XCUIApplication()
        app.launch()
     
        let NavigationTitle = app.staticTexts["Logbook"]
     
        XCTAssert(NavigationTitle.exists)
    }
    
    func testLoginButton() throws {
        let app = XCUIApplication()
        app.launch()
     
        let Edit = app.buttons["Edit"]
     
        XCTAssert(Edit.exists)
    }
}
