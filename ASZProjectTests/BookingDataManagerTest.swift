//
//  BookingDataManagerTest.swift
//  ASZProjectTests
//
//  Created by Tang on 2025/9/19.
//

import XCTest

final class BookingDataManagerTest: XCTestCase {

    var bookingDataManager: BookingDataManager!
    var mockService: BookingService!
    
    override func setUp() {
        super.setUp()
        bookingDataManager = BookingDataManager.shared
        mockService = MockBookingService()
    }

    override func tearDown() {
        bookingDataManager = nil
        mockService = nil
        super.tearDown()
    }
    
    func testGetBookingData_ForceRefreshTure () {
        bookingDataManager.getBookingData(forceRefresh: true) { result in
            switch result {
            case .success(let booking):
                XCTAssertNotNil(booking)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testGetBookingData_ForceRefreshFalse() {
        bookingDataManager.getBookingData { result in
            switch result {
            case .success(let booking):
                XCTAssertNotNil(booking)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    

}
