//
//  MaintenanceRequest.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

struct MaintenanceRequest: Codable, Identifiable {
    let id: String
    let userId: String
    let title: String
    let description: String
    let status: String
    let createdAt: String
}

