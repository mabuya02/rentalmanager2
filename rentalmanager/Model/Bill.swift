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
    let dueDate: String
}
