//
//  User.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

/// Represents a tenant user in the rental manager system.
struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let unitNumber: String
    let profileImage: String
    let createdAt: String
}

