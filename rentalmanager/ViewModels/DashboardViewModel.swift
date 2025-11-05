//
//  DashboardViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var totalUnpaidBills: String = "0"
    @Published var totalPayments: String = "0"
    @Published var totalDueAmount: String = "KES 0"
    @Published var activeMaintenanceCount: String = "0"
    @Published var recentPayments: [Payment] = []

    private let iso = ISO8601DateFormatter()

    func loadData(forUserId userId: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let bills = LocalStorageService.shared.fetchBills(for: userId)
            let payments = LocalStorageService.shared.fetchPayments(for: userId)
            let maintenance = LocalStorageService.shared.fetchMaintenanceRequests(for: userId)

            let unpaid = bills.filter { $0.status.lowercased() == "unpaid" }
            let unpaidCount = unpaid.count
            let totalUnpaid = unpaid.map { $0.amount }.reduce(0, +)

            let totalPaidAmount = payments.map { $0.amount }.reduce(0, +)
            let activeMaint = maintenance.filter { $0.status.lowercased() != "resolved" }.count

            let sortedRecent = payments.sorted { a, b in
                let da = self.iso.date(from: a.datePaid) ?? .distantPast
                let db = self.iso.date(from: b.datePaid) ?? .distantPast
                return da > db
            }

            DispatchQueue.main.async {
                self.totalUnpaidBills = "\(unpaidCount)"
                self.totalPayments = self.formatAmount(totalPaidAmount)
                self.totalDueAmount = self.formatAmount(totalUnpaid)
                self.activeMaintenanceCount = "\(activeMaint)"
                self.recentPayments = Array(sortedRecent.prefix(10))
                self.isLoading = false
            }
        }
    }

    func loadData(forEmail email: String) {
        let users = LocalStorageService.shared.fetchAllUsers()
        if let match = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
            loadData(forUserId: match.id)
        } else {
            DispatchQueue.main.async { self.isLoading = false }
        }
    }

    private func formatAmount(_ value: Double) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.groupingSeparator = ","
        return "KES " + (nf.string(from: NSNumber(value: value)) ?? "\(value)")
    }
}

