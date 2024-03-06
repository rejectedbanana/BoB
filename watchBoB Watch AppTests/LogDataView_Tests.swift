//
//  LogDataView_Tests.swift
//  watchBoB Watch AppTests
//
//  Created by Ramar Parham on 3/5/24.
//

import XCTest
@testable import watchBoB_Watch_App
import CoreData

final class LogDataView_Tests: XCTestCase {
    var metadataLogger: MetadataLogger!
    var moc: NSManagedObjectContext!
    var locationDataManager: LocationDataManager!
    
    override func setUp() {
            super.setUp()
            // Initialize CoreData stack
            let persistenceController = PersistenceController(inMemory: true)
            moc = persistenceController.container.viewContext
        
        locationDataManager = LocationDataManager()
            
            // Initialize MetadataLogger
            metadataLogger = MetadataLogger()
            //metadataLogger.context = moc
        }

        override func tearDown() {
            metadataLogger = nil
            super.tearDown()
        }
    
    func testIsLoggingStartsFalse() {
        XCTAssertFalse(metadataLogger.isLogging)
    }

        func testStartLogging() {
            metadataLogger.startLogging()
            XCTAssertTrue(metadataLogger.isLogging)
        }

        func testStopLogging() {
            // Ensure logging stops
            metadataLogger.startLogging()
            XCTAssertTrue(metadataLogger.isLogging)
            
            metadataLogger.stopLogging()
            XCTAssertFalse(metadataLogger.isLogging)
        }
}
