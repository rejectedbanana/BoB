//
//  watchBoB_Watch_AppTests.swift
//  watchBoB Watch AppTests
//
//  Created by Ramar Parham on 3/4/24.
//

import XCTest
@testable import watchBoB_Watch_App

final class watchBoB_Watch_AppTests: XCTestCase {

    var metadataLogger: MetadataLogger!
    var locationDataManager: LocationDataManager!
    var isLocationUpdating: Bool = false

        override func setUp() {
            super.setUp()
            metadataLogger = MetadataLogger()
            locationDataManager = LocationDataManager()
        }

        override func tearDown() {
            metadataLogger = nil
            locationDataManager = nil
            super.tearDown()
        }

        func testStartLogging() {
            metadataLogger.startLogging()
            XCTAssertTrue(metadataLogger.isLogging)
        }

        func testStopLogging() {
            metadataLogger.stopLogging()
            XCTAssertFalse(metadataLogger.isLogging)
        }

}

