//
//  BoB_UITests.swift
//  BoB_UITests
//
//  Created by Ramar Parham on 1/22/24.
//

import XCTest
@testable import BoB

final class BoB_UITests: XCTestCase {
    
    func testLakeWashington() throws {
        let app = XCUIApplication()
        app.launch()
     
        let lakeWashington = app.staticTexts["Lake Washington"]
     
        XCTAssert(lakeWashington.exists)
    }

    func testExportButton() throws {
        let app = XCUIApplication()
        app.launch()
     
        let export = app.buttons["Export"]
        
        XCTAssert(export.exists)
    }
}
