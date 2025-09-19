//
//  MockBookingServiceTest.swift
//  ASZProjectTests
//
//  Created by Tang on 2025/9/19.
//

import XCTest
@testable import ASZProject

final class MockBookingServiceTest: XCTestCase {
    
    var mockBookingService: BookingService!

    override func setUp() {
        super.setUp()
        mockBookingService = MockBookingService()
    }
    
    override func tearDown() {
        mockBookingService = nil
        super.tearDown()
    }
    
    func testFetchBookingData() {
        mockBookingService.fetchBookingData { result in
            switch result {
            case .success(let booking):
                XCTAssertNotNil(booking)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

}
