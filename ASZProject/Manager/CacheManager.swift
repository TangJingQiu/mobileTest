//
//  CacheManager.swift
//  ASZProject
//
//  Created by Tang on 2025/9/18.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let bookingKey = "cachedBookingData"
    private let expiryKey = "cachedBookingExpiry"
    
    func saveBooking(_ booking: Booking) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(booking)
            userDefaults.set(data, forKey: bookingKey)
            userDefaults.set(booking.expiryTime, forKey: expiryKey)
        } catch {
            print("Failed to save booking to cache: \(error)")
        }
    }
    
    func getCachedBooking() -> Booking? {
        guard let data = userDefaults.data(forKey: bookingKey),
              let expiryTime = userDefaults.object(forKey: expiryKey) as? TimeInterval else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            var booking = try decoder.decode(Booking.self, from: data)
            booking.expiryTime = "\(expiryTime)"
            
            // 检查是否过期
            if booking.isExpired {
                return nil
            }
            
            return booking
        } catch {
            print("Failed to decode cached booking: \(error)")
            return nil
        }
    }
    
    func clearCache() {
        userDefaults.removeObject(forKey: bookingKey)
        userDefaults.removeObject(forKey: expiryKey)
    }
}
