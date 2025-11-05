//
//  Bill.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

struct Bill: Codable, Identifiable {
    var id: String
    var userId: String
    var type: String
    var amount: Double
    var dueDate: String
    var status: String   // ✅ must be var

    var dueDateFormatted: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dueDate) {
            let display = DateFormatter()
            display.dateFormat = "MMM d, yyyy"
            return display.string(from: date)
        }
        return dueDate
    }
}


