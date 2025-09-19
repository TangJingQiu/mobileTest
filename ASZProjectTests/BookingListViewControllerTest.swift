//
//  BookingListViewControllerTest.swift
//  ASZProjectTests
//
//  Created by Tang on 2025/9/19.
//

import XCTest
@testable import ASZProject

final class BookingListViewControllerTest: XCTestCase {
    
    var viewController: BookingListViewController!
    
    override func setUp() {
        super.setUp()
        viewController = BookingListViewController()
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testNavTitle() {
        XCTAssertEqual(viewController.title, "Booking Segments")
    }

}
