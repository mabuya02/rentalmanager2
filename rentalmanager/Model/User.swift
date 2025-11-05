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
    var name: String
    let email: String
    var phone: String
    var unitNumber: String
    var profileImage: String
    let createdAt: String
}
