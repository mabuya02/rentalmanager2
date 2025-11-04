//
//  NotificationItem.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

struct NotificationItem: Codable, Identifiable {
    let id: String
    let userId: String
    let title: String
    let message: String
    let isRead: Bool
    let createdAt: String
}

