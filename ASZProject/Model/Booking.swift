//
//  Booking.swift
//  ASZProject
//
//  Created by Tang on 2025/9/18.
//

import Foundation

struct Booking: Codable {
    let shipReference: String
    let shipToken: String
    let canIssueTicketChecking: Bool
    var expiryTime: String
    let duration: Int
    let segments: [Segment]
    
    var isExpired: Bool {
        return Date().timeIntervalSince1970 > TimeInterval(expiryTime) ?? 0
    }
}

struct Segment: Codable, Identifiable {
    let id: Int
    let originAndDestinationPair: OriginDestinationPair
}

struct OriginDestinationPair: Codable {
    let destination: Location
    let destinationCity: String
    let origin: Location
    let originCity: String
}

struct Location: Codable {
    let code: String
    let displayName: String
    let url: String
}
