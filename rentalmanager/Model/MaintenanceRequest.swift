//
//  MaintenanceRequest.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import Foundation

struct MaintenanceRequest: Codable, Identifiable {
    let id: String
    let userId: String
    let title: String
    let description: String
    let status: String
    let createdAt: String

    var createdAtFormatted: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: createdAt) {
            let display = DateFormatter()
            display.dateStyle = .medium
            return display.string(from: date)
        }
        return createdAt
    }
}

