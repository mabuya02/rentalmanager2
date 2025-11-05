//
//  PaymentViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import Foundation
import Combine

final class PaymentViewModel: ObservableObject {
    @Published var payments: [Payment] = []

    var totalPaid: Double {
        payments.filter { $0.status.lowercased() == "successful" }
            .reduce(0) { $0 + $1.amount }
    }

    var successfulCount: Int {
        payments.filter { $0.status.lowercased() == "successful" }.count
    }

    // MARK: - Load
    func loadPayments(forUserId userId: String) {
        let all: [Payment] = LocalStorageService.shared.loadJSON([Payment].self, from: "payments")
        payments = all.filter { $0.userId == userId }.sorted { $0.datePaid > $1.datePaid }
    }

    func loadPayments(forEmail email: String) {
        let users = LocalStorageService.shared.fetchAllUsers()
        if let match = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
            loadPayments(forUserId: match.id)
        }
    }

    // MARK: - Add new payment
    func addPayment(for bill: Bill, method: String) {
        let newPayment = Payment(
            id: UUID().uuidString,
            userId: bill.userId,
            billId: bill.id,
            amount: bill.amount,
            method: method,
            reference: "TXN\(Int.random(in: 10000...99999))",
            status: "successful",
            datePaid: ISO8601DateFormatter().string(from: Date())
        )

        var allPayments: [Payment] = LocalStorageService.shared.loadJSON([Payment].self, from: "payments")
        allPayments.append(newPayment)
        LocalStorageService.shared.saveJSON(allPayments, to: "payments")

        DispatchQueue.main.async {
            self.payments = allPayments.filter { $0.userId == bill.userId }
        }

        print("💳 Payment added for bill \(bill.id) using \(method)")
    }
}

