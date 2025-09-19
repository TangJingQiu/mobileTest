//
//  BookingTest.swift
//  ASZProjectTests
//
//  Created by Tang on 2025/9/19.
//

import XCTest
@testable import ASZProject

class BookingTest: XCTestCase {
    
    func testBookingInitialization_Success() {
        let destination: Location = Location(code: "BBB", displayName: "BBB DisplayName", url: "www.ship.com")
        let origin: Location = Location(code: "AAA", displayName: "AAA DisplayName", url: "www.ship.com")
        
        let originAndDestinationPair: OriginDestinationPair = OriginDestinationPair(destination: destination, destinationCity: "AAA", origin: origin, originCity: "BBB")
        
        let segments: [Segment] = [Segment(id: 1, originAndDestinationPair: originAndDestinationPair)]
        
        let booking = Booking(shipReference: "ABCDEF", shipToken: "AAAABBBCCCCDDD", canIssueTicketChecking: false, expiryTime: "1722409261", duration: 2430, segments: segments)
        
        
        XCTAssertNotNil(booking)
        XCTAssertEqual(booking.shipReference, "ABCDEF")
        XCTAssertEqual(booking.shipToken, "AAAABBBCCCCDDD")
        XCTAssertFalse(booking.canIssueTicketChecking)
        XCTAssertEqual(booking.expiryTime, "1722409261")
        XCTAssertEqual(booking.duration, 2430)
        
        XCTAssertTrue(booking.isExpired)
        
        
        XCTAssertEqual(booking.segments[0].id, 1)
        XCTAssertEqual(booking.segments[0].originAndDestinationPair.destination.code, "BBB")
        XCTAssertEqual(booking.segments[0].originAndDestinationPair.origin.displayName, "AAA DisplayName")
    }
    
    func testBookingInitialization_Failure() {
        XCTAssertNotNil(Booking(shipReference: "", shipToken: "", canIssueTicketChecking: true, expiryTime: "\(Date().timeIntervalSince1970)", duration: 0, segments: []))
        XCTAssertNotNil(Booking(shipReference: "", shipToken: "", canIssueTicketChecking: false, expiryTime: "1722409261", duration: 0, segments: []))
    }
}


