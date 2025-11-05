//
//  ProfileViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    // Loaded user object
    @Published var user: User? = nil

    // Editable fields
    @Published var userName: String = ""
    @Published var phone: String = ""
    @Published var unitNumber: String = ""
    @Published var profileImageURL: String = ""

    // Optional rental summary (static placeholders for now)
    @Published var propertyName: String = "Westlands Heights Apartments"
    @Published var leaseEndDate: String = "31 Dec 2026"
    @Published var rentDue: Double = 48_000.0

    private let storage = LocalStorageService.shared

    // MARK: - Load Profile
    func loadProfile(for email: String) {
        let users = storage.fetchAllUsers()
        if let match = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
            user = match
            userName = match.name
            phone = match.phone
            unitNumber = match.unitNumber
            profileImageURL = match.profileImage
        } else {
            print("⚠️ No user found with email \(email)")
        }
    }

    // MARK: - Save Changes
    func saveProfileChanges() {
        guard var existingUser = user else { return }

        existingUser.name = userName
        existingUser.phone = phone
        existingUser.unitNumber = unitNumber
        existingUser.profileImage = profileImageURL

        storage.update(existingUser, in: "users")
        user = existingUser

        print("✅ Profile updated for user: \(userName)")
    }

    // MARK: - Support Actions
    func contactSupport() {
        if let url = URL(string: "mailto:support@rentalmanager.app?subject=Support Request") {
            UIApplication.shared.open(url)
        }
    }

    func showAbout() {
        let alert = UIAlertController(
            title: "About RentalManager",
            message: """
            RentalManager v1.0
            Built with ❤️ by Manasseh Mabuya Maina

            This app helps you manage your rental, track bills, and handle maintenance requests easily.
            """,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.topMostController()?.present(alert, animated: true)
    }
}
