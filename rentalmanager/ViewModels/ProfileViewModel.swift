//
//  ProfileViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import Foundation
import Combine   // ✅ Needed for ObservableObject / @Published

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false

    func loadProfile(for userEmail: String) {
        isLoading = true

        Task {
            // Run file IO off the main thread
            let users = await Self.background {
                LocalStorageService.shared.fetchAllUsers()
            }

            let match = users.first {
                $0.email.lowercased() == userEmail.lowercased()
            }

            self.user = match
            self.isLoading = false
        }
    }

    // MARK: - Utility helper for background work
    private static func background<T>(_ work: @escaping () -> T) async -> T {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                continuation.resume(returning: work())
            }
        }
    }
}

