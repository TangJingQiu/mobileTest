//
//  CacheManagerTest.swift
//  ASZProjectTests
//
//  Created by Tang on 2025/9/19.
//

import XCTest

final class CacheManagerTest: XCTestCase {
    
    var cacheManage: CacheManager!
    
    private let userDefaults = UserDefaults.standard
    private let bookingKey = "cachedBookingData"
    private let expiryKey = "cachedBookingExpiry"

    override func setUp() {
        super.setUp()
        cacheManage = CacheManager.shared
        
    }

    override func tearDown() {
        cacheManage = nil
        super.tearDown()
    }

    func testCacheManage() {
        XCTAssertNotNil(cacheManage)
    }
    
    func testSaveBooking() {
        let booking = Booking(shipReference: "ABCDEF", shipToken: "AAAABBBCCCCDDD", canIssueTicketChecking: false, expiryTime: "\(Date().timeIntervalSince1970)", duration: 2430, segments: [])
        cacheManage.saveBooking(booking)
        
        let expiryTime = userDefaults.string(forKey: expiryKey)
        XCTAssertEqual(expiryTime, booking.expiryTime)
        
    }
    
    func testGetCachedBooking_Success() {
        let booking = Booking(shipReference: "ABCDEF", shipToken: "AAAABBBCCCCDDD", canIssueTicketChecking: false, expiryTime: "\(Date().timeIntervalSince1970)", duration: 2430, segments: [])
        cacheManage.saveBooking(booking)
        let cacheBooking = cacheManage.getCachedBooking()
        XCTAssertEqual(cacheBooking?.shipReference, Optional("ABCDEF"))
        XCTAssertEqual(cacheBooking?.shipToken, Optional("AAAABBBCCCCDDD"))
    }
    
    func testGetCachedBooking_Expired() {
        let booking = Booking(shipReference: "ABCDEF", shipToken: "AAAABBBCCCCDDD", canIssueTicketChecking: false, expiryTime: "1722409261", duration: 2430, segments: [])
        cacheManage.saveBooking(booking)

        let cacheBooking = cacheManage.getCachedBooking()
        XCTAssertEqual(cacheBooking?.shipReference, nil)
        XCTAssertEqual(cacheBooking?.shipToken, nil)
    }
    
    func testClearCache() {
        let booking = Booking(shipReference: "ABCDEF", shipToken: "AAAABBBCCCCDDD", canIssueTicketChecking: false, expiryTime: "1722409261", duration: 2430, segments: [])
        cacheManage.saveBooking(booking)
        _ = cacheManage.getCachedBooking()
        cacheManage.clearCache()
        
        let bookingKey = userDefaults.data(forKey: bookingKey)
        let expiryTime = userDefaults.string(forKey: expiryKey)
        XCTAssertNil(bookingKey)
        XCTAssertNil(expiryTime)
    }

}
