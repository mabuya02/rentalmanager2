//
//  Bill.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

struct Bill: Codable, Identifiable {
    let id: String
    let userId: String
    let type: String
    let amount: Double
    let status: String
    let dueDate: String   // stored as ISO string in JSON

    // ✅ Computed property to safely format the string date
    var dueDateFormatted: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dueDate) {
            let display = DateFormatter()
            display.dateFormat = "MMM d, yyyy"
            return display.string(from: date)
        } else {
            return dueDate // fallback if parsing fails
        }
    }
}

