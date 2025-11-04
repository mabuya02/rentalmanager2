//
//  BillViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import Foundation
import Combine

@MainActor
final class BillViewModel: ObservableObject {
    @Published var bills: [Bill] = []
    @Published var totalUnpaid: Double = 0.0

    private let storage = LocalStorageService.shared

    func loadBills(for userId: String) {
        let fetchedBills = storage.fetchBills(for: userId)
        bills = fetchedBills.sorted { $0.dueDate < $1.dueDate }
        totalUnpaid = fetchedBills.filter { $0.status.lowercased() == "unpaid" }.reduce(0) { $0 + $1.amount }
    }
}

