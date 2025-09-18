//
//  BookingDataManager.swift
//  ASZProject
//
//  Created by Tang on 2025/9/18.
//

import Foundation

class BookingDataManager {
    static let shared = BookingDataManager()
    private init() {}
    
    private let service: BookingService = MockBookingService()
    private let cacheManager = CacheManager.shared
    
    private var currentBooking: Booking?
    private var isFetching = false
    private var completionQueue = DispatchQueue(label: "com.booking.completionQueue", qos: .userInitiated)
    
    // 获取数据（带缓存处理）
    func getBookingData(forceRefresh: Bool = false, completion: @escaping (Result<Booking, Error>) -> Void) {
        // 1. 如果有强制刷新或没有缓存数据，从网络获取
        if forceRefresh || currentBooking == nil {
            fetchFreshData(completion: completion)
            return
        }
        
        // 2. 否则返回缓存数据
        if let cachedBooking = currentBooking {
            completionQueue.async {
                completion(.success(cachedBooking))
            }
        }
    }
    
    private func fetchFreshData(completion: @escaping (Result<Booking, Error>) -> Void) {
        guard !isFetching else {
            // 如果已经在获取数据，将completion加入队列
            completionQueue.async {
                if let currentBooking = self.currentBooking {
                    completion(.success(currentBooking))
                }
            }
            return
        }
        
        isFetching = true
        
        service.fetchBookingData { [weak self] result in
            guard let self = self else { return }
            
            defer {
                DispatchQueue.main.async {
                    self.isFetching = false
                }
            }
            
            switch result {
            case .success(let booking):
                // 保存到内存和本地缓存
                self.currentBooking = booking
                self.cacheManager.saveBooking(booking)
                
                self.completionQueue.async {
                    completion(.success(booking))
                }
                
            case .failure(let error):
                // 网络请求失败，尝试从缓存加载
                if let cachedBooking = self.cacheManager.getCachedBooking() {
                    self.currentBooking = cachedBooking
                    self.completionQueue.async {
                        completion(.success(cachedBooking))
                    }
                } else {
                    self.completionQueue.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
