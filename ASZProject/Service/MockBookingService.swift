//
//  MockBookingService.swift
//  ASZProject
//
//  Created by Tang on 2025/9/18.
//

import Foundation

class MockBookingService: BookingService {
    func fetchBookingData(completion: @escaping (Result<Booking, Error>) -> Void) {
        // 模拟网络延迟
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            do {
                // 从本地JSON文件加载模拟数据
                guard let url = Bundle.main.url(forResource: "booking", withExtension: "json") else {
                    throw NSError(domain: "MockBookingService", code: 404, userInfo: [NSLocalizedDescriptionKey: "JSON file not found"])
                }
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let booking = try decoder.decode(Booking.self, from: data)
                
                // 模拟有时效性的数据
                var mutableBooking = booking
                // 如果数据已过期，设置新的过期时间（当前时间+1小时）
                if mutableBooking.isExpired {
                    mutableBooking.expiryTime = "\(Date().timeIntervalSince1970 + 3600)" 
                }
                
                completion(.success(mutableBooking))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
