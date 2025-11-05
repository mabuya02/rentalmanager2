//
//  BillViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import Foundation
import Combine

final class BillViewModel: ObservableObject {
    @Published var bills: [Bill] = []
    private let storage = LocalStorageService.shared

    // MARK: - Totals
    var totalUnpaid: Double {
        bills.filter { $0.status.lowercased() == "unpaid" }
            .reduce(0) { $0 + $1.amount }
    }

    var totalPaid: Double {
        bills.filter { $0.status.lowercased() == "paid" }
            .reduce(0) { $0 + $1.amount }
    }

    // MARK: - Load
    func loadBills(for userId: String) {
        bills = storage.fetchBills(for: userId)
    }

    // MARK: - Mark Bill as Paid (Auto-create payment)
    func markBillAsPaid(_ bill: Bill, method: String) {
        // Find and update in local storage
        var updatedBill = bill
        updatedBill.status = "paid"

        // Load all bills
        var allBills: [Bill] = storage.fetchBills(for: updatedBill.userId)

        // Update matching bill in global dataset
        var globalBills: [Bill] = storage.fetchAllBills()
        if let globalIndex = globalBills.firstIndex(where: { $0.id == bill.id }) {
            globalBills[globalIndex] = updatedBill
            storage.saveJSON(globalBills, to: "bills")
        }

        // Update local list for the current user
        DispatchQueue.main.async {
            self.bills = globalBills.filter { $0.userId == updatedBill.userId }
        }

        // Create a payment record
        let paymentVM = PaymentViewModel()
        paymentVM.addPayment(for: updatedBill, method: method)

        print("✅ Bill \(bill.id) marked as paid and payment recorded using \(method).")
    }
}

// MARK: - LocalStorageService helper extension
extension LocalStorageService {
    /// Quick access to all bills (used by ViewModel)
    func fetchAllBills() -> [Bill] {
        loadJSON([Bill].self, from: "bills")
    }
}

