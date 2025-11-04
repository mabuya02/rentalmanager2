//
//  Payment.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
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

    var dateFormatted: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: datePaid) {
            let display = DateFormatter()
            display.dateFormat = "MMM d, yyyy"
            return display.string(from: date)
        }
        return datePaid
    }
}

