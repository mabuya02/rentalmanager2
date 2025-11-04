//
//  DashboardViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import SwiftUI
import Combine
import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var totalUnpaidBills: String = "0.00"
    @Published var totalPayments: String = "0.00"
    @Published var activeMaintenanceCount: Int = 0
    @Published var isLoading: Bool = false

    private let storage = LocalStorageService.shared

    // MARK: - Load dashboard data
    func loadData(for userEmail: String) {
        guard !userEmail.isEmpty else {
            print("⚠️ Dashboard load skipped: userEmail empty")
            return
        }

        isLoading = true
        Task {
            defer { isLoading = false }

            let users = storage.fetchAllUsers()
            guard let user = users.first(where: { $0.email.lowercased() == userEmail.lowercased() }) else {
                print("⚠️ No user found for email: \(userEmail)")
                return
            }

            let bills = storage.fetchBills(for: user.id)
            let payments = storage.fetchPayments(for: user.id)
            let maintenance = storage.fetchMaintenanceRequests(for: user.id)

            // Compute totals
            let unpaidTotal = bills
                .filter { $0.status.lowercased() == "unpaid" }
                .reduce(0.0) { $0 + $1.amount }

            let paidTotal = payments.reduce(0.0) { $0 + $1.amount }

            // Format amounts nicely
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "KES"
            formatter.maximumFractionDigits = 2

            totalUnpaidBills = formatter.string(from: NSNumber(value: unpaidTotal)) ?? "KES 0.00"
            totalPayments = formatter.string(from: NSNumber(value: paidTotal)) ?? "KES 0.00"
            activeMaintenanceCount = maintenance.filter { $0.status.lowercased() != "resolved" }.count

            print("✅ Dashboard loaded for user: \(user.name)")
        }
    }
}

