//
//  DashboardViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var totalUnpaidBills: String = "0"
    @Published var totalPayments: String = "0"
    @Published var activeMaintenanceCount: String = "0"
    @Published var isLoading = false

    private let storage = LocalStorageService.shared

    // ✅ Load using Firebase UID
    func loadData(forUserId userId: String) {
        isLoading = true
        DispatchQueue.global(qos: .background).async {
            let bills = self.storage.fetchBills(for: userId)
            let payments = self.storage.fetchPayments(for: userId)
            let maintenance = self.storage.fetchMaintenanceRequests(for: userId)

            let unpaidTotal = bills
                .filter { $0.status.lowercased() == "unpaid" }
                .reduce(0.0) { $0 + $1.amount }

            let paidTotal = payments.reduce(0.0) { $0 + $1.amount }

            let activeMaintenance = maintenance
                .filter { $0.status.lowercased() != "resolved" }
                .count

            Task { @MainActor in
                self.totalUnpaidBills = String(format: "KES %.0f", unpaidTotal)
                self.totalPayments = String(format: "KES %.0f", paidTotal)
                self.activeMaintenanceCount = "\(activeMaintenance)"
                self.isLoading = false
            }
        }
    }

    // ✅ Fallback – if only email is available
    func loadData(forEmail email: String) {
        isLoading = true
        DispatchQueue.global(qos: .background).async {
            let users = self.storage.fetchAllUsers()
            guard let user = users.first(where: {
                $0.email.lowercased() == email.lowercased()
            }) else {
                Task { @MainActor in self.isLoading = false }
                return
            }

            // ✅ Call safely back on main actor
            Task { @MainActor in
                self.loadData(forUserId: user.id)
            }
        }
    }
}

