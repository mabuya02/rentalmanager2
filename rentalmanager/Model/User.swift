//
//  User.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

/// Represents a tenant user in the rental manager system.
struct User: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var phone: String
    var apartmentNumber: String
    var propertyName: String
    var leaseStatus: String
}

