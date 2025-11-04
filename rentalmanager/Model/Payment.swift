//
//  Payment.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

struct Payment: Codable, Identifiable {
    let id: String
    let userId: String
    let billId: String
    let amount: Double
    let method: String
    let reference: String
    let status: String
    let datePaid: String
}
