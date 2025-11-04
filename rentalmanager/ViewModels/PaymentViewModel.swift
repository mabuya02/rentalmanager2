//
//  PaymentViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import Foundation
import Combine

@MainActor
final class PaymentViewModel: ObservableObject {
    @Published var payments: [Payment] = []
    @Published var selectedPayment: Payment?

    private let storage = LocalStorageService.shared

    /// Load payments using Firebase UID (preferred)
    func loadPayments(forUserId userId: String) {
        Task {
            // Run background JSON read
            let fetched = await Self.background {
                LocalStorageService.shared.fetchPayments(for: userId)
            }

            // Update UI safely on MainActor
            self.payments = fetched
        }
    }

    /// Fallback: load payments via email
    func loadPayments(forEmail email: String) {
        Task {
            let emailLower = email.lowercased()

            // Fetch users off main actor
            let users = await Self.background {
                LocalStorageService.shared.fetchAllUsers()
            }

            guard let user = users.first(where: { $0.email.lowercased() == emailLower }) else {
                self.payments = []
                return
            }

            // Fetch payments for that user
            let fetched = await Self.background {
                LocalStorageService.shared.fetchPayments(for: user.id)
            }

            self.payments = fetched
        }
    }

    /// Add a new payment locally (write JSON, then reflect in UI)
    func addPayment(_ payment: Payment) {
        Task {
            // Run the file write off the main thread
            await Self.background {
                LocalStorageService.shared.add(payment, to: "payments")
            }

            // Reflect in-memory update on UI
            self.payments.append(payment)
        }
    }

    func selectPayment(_ payment: Payment) {
        selectedPayment = payment
    }

    // MARK: - Utility helper to safely run background I/O
    private static func background<T>(_ work: @escaping () -> T) async -> T {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                continuation.resume(returning: work())
            }
        }
    }
}

