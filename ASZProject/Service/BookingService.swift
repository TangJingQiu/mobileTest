//
//  BookingService.swift
//  ASZProject
//
//  Created by Tang on 2025/9/18.
//

import Foundation

protocol BookingService {
    func fetchBookingData(completion: @escaping (Result<Booking, Error>) -> Void)
}
