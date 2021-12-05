//
//  DatabaseHandlerTests.swift
//  ExpensesAppTests
//
//  Created by Mohammed1 Shoeb on 02/12/21.
//

import XCTest
import CoreData
@testable import ExpensesApp

class DatabaseHandlerTests: XCTestCase {
    var coreDataManager: DatabaseHandler?
    
    override func setUpWithError() throws {
        self.coreDataManager = DatabaseHandler()
    }

    override func tearDownWithError() throws {
        self.coreDataManager = nil
        super.tearDown()
    }
    func test_init_coreDataManager(){
        let instance = DatabaseHandler.shared
        XCTAssertNotNil( instance )
    }
    func test_coreDataStackInitialization() {
        let coreDataStack = DatabaseHandler.shared.viewContext
      XCTAssertNotNil( coreDataStack )
    }
 
}
