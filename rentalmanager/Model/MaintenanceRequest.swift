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
    var status: String              // ← was let; now var so we can update it
    let createdAt: String           // ISO8601 string

    var createdAtFormatted: String {
        let iso = ISO8601DateFormatter()
        if let date = iso.date(from: createdAt) {
            let df = DateFormatter()
            df.dateStyle = .medium
            return df.string(from: date)
        }
        return createdAt
    }
}

